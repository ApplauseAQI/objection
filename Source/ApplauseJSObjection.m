#import "ApplauseJSObjection.h"
#import <pthread.h>
#import "ApplauseJSObjectionInjectorEntry.h"
#import "ApplauseJSObjectionRuntimePropertyReflector.h"

static NSMutableDictionary *gObjectionContext;
static pthread_mutex_t gObjectionMutex;
static ApplauseJSObjectionInjector *gGlobalInjector;
static id<ApplauseJSObjectionPropertyReflector> gPropertyReflector;

@implementation ApplauseJSObjection

+ (ApplauseJSObjectionInjector *)createInjector:(ApplauseJSObjectionModule *)module {
        pthread_mutex_lock(&gObjectionMutex);
        @try {
            return [[ApplauseJSObjectionInjector alloc] initWithContext:gObjectionContext andModule:module];
        }
        @finally {
            pthread_mutex_unlock(&gObjectionMutex); 
        }

        return nil;
}

+ (ApplauseJSObjectionInjector *)createInjectorWithModulesArray:(NSArray *)modules {
    pthread_mutex_lock(&gObjectionMutex);
    @try {
        return [[ApplauseJSObjectionInjector alloc] initWithContext:gObjectionContext andModules:modules];
    }
    @finally {
        pthread_mutex_unlock(&gObjectionMutex);
    }
    
    return nil;
}

+ (ApplauseJSObjectionInjector *)createInjectorWithModules:(ApplauseJSObjectionModule *)first, ... {
    va_list va_modules;
    NSMutableArray *modules = [NSMutableArray arrayWithObject:first];
    va_start(va_modules, first);

    ApplauseJSObjectionModule *module;
    while ((module = va_arg( va_modules, ApplauseJSObjectionModule *) )) {
        [modules addObject:module];
    }

    va_end(va_modules);
    return [self createInjectorWithModulesArray:modules];
}

+ (ApplauseJSObjectionInjector *)createInjector {
    pthread_mutex_lock(&gObjectionMutex);
    @try {
        return [[ApplauseJSObjectionInjector alloc] initWithContext:gObjectionContext];
    }
    @finally {
        pthread_mutex_unlock(&gObjectionMutex); 
    }

    return nil;
}

+ (void)initialize  {
    if (self == [ApplauseJSObjection class]) {
        gObjectionContext = [[NSMutableDictionary alloc] init];
        gPropertyReflector = [[ApplauseJSObjectionRuntimePropertyReflector alloc] init];
        pthread_mutexattr_t mutexattr;
        pthread_mutexattr_init(&mutexattr);
        pthread_mutexattr_settype(&mutexattr, PTHREAD_MUTEX_RECURSIVE);
        pthread_mutex_init(&gObjectionMutex, &mutexattr);
        pthread_mutexattr_destroy(&mutexattr);    
    }
}

+ (void) registerClass:(Class)theClass scope:(ApplauseJSObjectionScope)scope {
    pthread_mutex_lock(&gObjectionMutex);
    if (scope != ApplauseJSObjectionScopeSingleton && scope != ApplauseJSObjectionScopeNormal) {
        @throw [NSException exceptionWithName:@"JSObjectionInjectorException" reason:@"Invalid Instantiation Rule" userInfo:nil];
    }

    if (theClass && [gObjectionContext objectForKey:NSStringFromClass(theClass)] == nil) {
        [gObjectionContext setObject:[ApplauseJSObjectionInjectorEntry entryWithClass:theClass scope:scope] forKey:NSStringFromClass(theClass)];
    } 
    pthread_mutex_unlock(&gObjectionMutex);
}

+ (void) reset {
    pthread_mutex_lock(&gObjectionMutex);
    [gObjectionContext removeAllObjects];
    pthread_mutex_unlock(&gObjectionMutex);
}

+ (void)setDefaultInjector:(ApplauseJSObjectionInjector *)anInjector {
    if (gGlobalInjector != anInjector) {
        gGlobalInjector = anInjector;
    }
}

+ (ApplauseJSObjectionInjector *) defaultInjector {
    return gGlobalInjector;
}

+ (ApplauseJSObjectionPropertyInfo)propertyForClass:(Class)theClass andProperty:(NSString *)propertyName {
    return [gPropertyReflector propertyForClass:theClass andProperty: propertyName];
}

+ (void)setPropertyReflector:(id<ApplauseJSObjectionPropertyReflector>)reflector {
    if(gPropertyReflector != reflector) {
        gPropertyReflector = reflector;
    }
}
@end
