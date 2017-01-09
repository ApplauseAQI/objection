#import "ApplauseJSObjectionInjector.h"
#import "ApplauseJSObjectionEntry.h"
#import "ApplauseJSObjectFactory.h"
#import "ApplauseJSObjectionUtils.h"
#import "ApplauseJSObjectionInjectorEntry.h"

#import <pthread.h>
#import <objc/runtime.h>

@interface __ApplauseJSObjectionInjectorDefaultModule : ApplauseJSObjectionModule

@property (nonatomic, weak) ApplauseJSObjectionInjector *injector;

@end

@implementation __ApplauseJSObjectionInjectorDefaultModule

- (instancetype)initWithInjector:(ApplauseJSObjectionInjector *)injector {
    if ((self = [super init])) {
        self.injector = injector;
    }
    return self;
}

- (void)configure   {
    [self bind:[[ApplauseJSObjectFactory alloc] initWithInjector:self.injector] toClass:[ApplauseJSObjectFactory class]];
}

@end
  
@interface ApplauseJSObjectionInjector() {
  NSDictionary *_globalContext;
  NSMutableDictionary *_context;
  NSSet *_eagerSingletons;
  NSMutableArray *_modules;
}

- (void)initializeEagerSingletons;
- (void)configureDefaultModule;
- (void)configureModule:(ApplauseJSObjectionModule *)module;

@end

@implementation ApplauseJSObjectionInjector

- (instancetype)initWithContext:(NSDictionary *)theGlobalContext {
    if ((self = [super init])) {
        _globalContext = theGlobalContext;
        _context = [[NSMutableDictionary alloc] init];
        _modules = [[NSMutableArray alloc] init];
        [self configureDefaultModule];
        [self initializeEagerSingletons];
    }

    return self;
}

- (instancetype)initWithContext:(NSDictionary *)theGlobalContext andModule:(ApplauseJSObjectionModule *)theModule {
    if ((self = [self initWithContext:theGlobalContext])) {
        [self configureModule:theModule];
        [self initializeEagerSingletons];
    }
    return self;
}

- (instancetype)initWithContext:(NSDictionary *)theGlobalContext andModules:(NSArray *)theModules {
    if ((self = [self initWithContext:theGlobalContext])) {
        for (ApplauseJSObjectionModule *module in theModules) {
            [self configureModule:module];      
        }
        [self initializeEagerSingletons];
    }
    return self;  
}

- (id)getObject:(id)classOrProtocol {
    return [self getObjectWithArgs:classOrProtocol, nil];
}

- (id)getObject:(id)classOrProtocol named:(NSString*)name {
    return [self getObject:classOrProtocol namedWithArgs:name, nil];
}

- (id)getObjectWithArgs:(id)classOrProtocol, ... {
    va_list va_arguments;
    va_start(va_arguments, classOrProtocol);
    id object = [self getObject:classOrProtocol arguments:va_arguments];
    va_end(va_arguments);
    return object;
}

- (id)getObject:(id)classOrProtocol namedWithArgs:(NSString *)name, ... {
    va_list va_arguments;
    va_start(va_arguments, name);
    id object = [self getObject:classOrProtocol named:name arguments:va_arguments];
    va_end(va_arguments);
    return object;
}

- (id)getObject:(id)classOrProtocol arguments:(va_list)argList {
    return [self getObject:classOrProtocol named:nil arguments:argList];
}

- (id)getObject:(id)classOrProtocol initializer:(SEL)selector argumentList:(NSArray *)argumentList {
    return [self getObject:classOrProtocol named:nil initializer:selector argumentList:argumentList];
}

- (id)getObject:(id)classOrProtocol named:name arguments:(va_list)argList {
    NSArray *arguments = ApplauseJSObjectionUtils.transformVariadicArgsToArray(argList);
    return [self getObject:classOrProtocol named:name argumentList:arguments];
}

- (id)getObject:(id)classOrProtocol argumentList:(NSArray *)argumentList {
   return [self getObject:classOrProtocol named:nil argumentList:argumentList];
}

- (id)getObject:(id)classOrProtocol named:(NSString*)name initializer:(SEL)selector argumentList:(NSArray *)argumentList {
    @synchronized(self) {
        if (!classOrProtocol) {
            return nil;
        }
        NSString *key = nil;
        BOOL isClass = class_isMetaClass(object_getClass(classOrProtocol));
        
        if (isClass) {
            key = NSStringFromClass(classOrProtocol);
        } else {
            key = [NSString stringWithFormat:@"<%@>", NSStringFromProtocol(classOrProtocol)];
        }
        
        if (name)
        {
            key = [NSString stringWithFormat:@"%@:%@",key,name];
        }
        
        id<ApplauseJSObjectionEntry> injectorEntry = [_context objectForKey:key];
        injectorEntry.injector = self;
        
        if (!injectorEntry) {
            id<ApplauseJSObjectionEntry> entry = [_globalContext objectForKey:key];
            if (entry) {
                injectorEntry = [[entry class] entryWithEntry:entry];
                injectorEntry.injector = self;
                [_context setObject:injectorEntry forKey:key];
            } else if(isClass) {
                injectorEntry = [ApplauseJSObjectionInjectorEntry entryWithClass:classOrProtocol scope:ApplauseJSObjectionScopeNormal];
                injectorEntry.injector = self;
                [_context setObject:injectorEntry forKey:key];
            }
        }
        
        if (classOrProtocol && injectorEntry) {
            if ([injectorEntry respondsToSelector:@selector(extractObject:initializer:)]) {
                return [injectorEntry extractObject:argumentList initializer:selector];
            }
            return [injectorEntry extractObject:argumentList];
        }
        
        return nil;
    }
    
    return nil;
  
}

- (id)getObject:(id)classOrProtocol named:(NSString*)name argumentList:(NSArray *)argumentList {
    return [self getObject:classOrProtocol named:name initializer: nil argumentList:argumentList];
}

- (id)objectForKeyedSubscript: (id)key {
    return [self getObjectWithArgs:key, nil];
}


- (id)withModule:(ApplauseJSObjectionModule *)theModule {
    return [self withModuleCollection:[NSArray arrayWithObject:theModule]];    
}

- (id)withModules:(ApplauseJSObjectionModule *)first, ... {
    va_list va_modules;
    NSMutableArray *modules = [NSMutableArray arrayWithObject:first];
    va_start(va_modules, first);
    
    ApplauseJSObjectionModule *module;
    while ((module = va_arg( va_modules, ApplauseJSObjectionModule *) )) {
        [modules addObject:module];
    }
    
    va_end(va_modules);
    return [self withModuleCollection:modules];
   
}

- (id)withModuleCollection:(NSArray *)theModules {
    NSMutableArray *mergedModules = [NSMutableArray arrayWithArray:_modules];
    [mergedModules addObjectsFromArray:theModules];
    return [[[self class] alloc] initWithContext:_globalContext andModules:mergedModules];
}

- (id)withoutModuleOfType:(Class)moduleClass {
    return [self withoutModuleCollection:[NSArray arrayWithObject:moduleClass]];
}

- (id)withoutModuleOfTypes:(Class)first, ... {
    va_list va_modules;
    NSMutableArray *classes = [NSMutableArray arrayWithObject:first];
    va_start(va_modules, first);
    
    Class aClass;
    while ((aClass = va_arg( va_modules, Class) )) {
        [classes addObject:aClass];
    }
    
    va_end(va_modules);
    return [self withoutModuleCollection:classes];

}

- (id)withoutModuleCollection:(NSArray *)moduleClasses {
    NSMutableArray *remainingModules = [NSMutableArray arrayWithArray:_modules];
    NSMutableArray *withDefaultModule = [NSMutableArray arrayWithArray:moduleClasses];
    [withDefaultModule addObject:[__ApplauseJSObjectionInjectorDefaultModule class]];
    for (ApplauseJSObjectionModule *module in _modules) {
        for (Class moduleClass in withDefaultModule) {
            if([module isKindOfClass:moduleClass]) {
                [remainingModules removeObject:module];
            }
        }
    }
    return [[[self class] alloc] initWithContext:_globalContext andModules:remainingModules];
}


- (void)injectDependencies:(id)object {
    ApplauseJSObjectionUtils.injectDependenciesIntoProperties(self, [object class], object);
}

- (NSArray *)modules {
    return [_modules copy];
}


#pragma mark - Private

- (void)initializeEagerSingletons {
    for (NSString *eagerSingletonKey in _eagerSingletons) {
        id entry = [_context objectForKey:eagerSingletonKey] ?: [_globalContext objectForKey:eagerSingletonKey];
        if ([entry lifeCycle] == ApplauseJSObjectionScopeSingleton) {
            [self getObject:NSClassFromString(eagerSingletonKey)];      
        } else {
            @throw [NSException exceptionWithName:@"ApplauseJSObjectionException"
                                           reason:[NSString stringWithFormat:@"Unable to initialize eager singleton for the class '%@' because it was never registered as a singleton", eagerSingletonKey] 
                                         userInfo:nil];
        }
    }
}

- (void)configureModule:(ApplauseJSObjectionModule *)module {
    [_modules addObject:module];
    [module configure];
    NSSet *mergedSet = [module.eagerSingletons setByAddingObjectsFromSet:_eagerSingletons];
    _eagerSingletons = mergedSet;
    [_context addEntriesFromDictionary:module.bindings];
}

- (void)configureDefaultModule {
    __ApplauseJSObjectionInjectorDefaultModule *module = [[__ApplauseJSObjectionInjectorDefaultModule alloc] initWithInjector:self];
    [self configureModule:module];
}

#pragma mark -


@end
