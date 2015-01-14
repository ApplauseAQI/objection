#import "ApplauseJSObjectionModule.h"
#import "ApplauseJSObjectionBindingEntry.h"
#import "ApplauseJSObjectionInjectorEntry.h"
#import <objc/runtime.h>
#import "ApplauseJSObjectionProviderEntry.h"
#import "ApplauseJSObjectionInjector.h"

@interface __ApplauseJSClassProvider : NSObject<ApplauseJSObjectionProvider>
{
    Class _class;
}
- (id)initWithClass:(Class)aClass;
@end

@implementation __ApplauseJSClassProvider

- (id)initWithClass:(Class)aClass {
    if ((self = [super init])) {
        _class = aClass;
    }
    return self;
}

- (id)provide:(ApplauseJSObjectionInjector *)context arguments:(NSArray *)arguments {
    return [context getObject:_class argumentList:arguments];
}

@end

@interface ApplauseJSObjectionModule ()
- (NSString *)protocolKey:(Protocol *)aProtocol;
- (void)ensureInstance:(id)instance conformsTo:(Protocol *)aProtocol;
@end

@implementation ApplauseJSObjectionModule
@synthesize bindings = _bindings;
@synthesize eagerSingletons = _eagerSingletons;

- (id)init {
    if ((self = [super init])) {
        _bindings = [[NSMutableDictionary alloc] init];
        _eagerSingletons = [[NSMutableSet alloc] init];
    }
    return self;
}

- (void)bindMetaClass:(Class)metaClass toProtocol:(Protocol *)aProtocol {
    if (!class_isMetaClass(object_getClass(metaClass))) {
        @throw [NSException exceptionWithName:@"JSObjectionException" 
                                       reason:[NSString stringWithFormat:@"\"%@\" can not be bound to the protocol \"%@\" because it is not a meta class", metaClass, NSStringFromProtocol(aProtocol)]
                                     userInfo:nil];
    }    
    NSString *key = [self protocolKey:aProtocol];
    ApplauseJSObjectionBindingEntry *entry = [[ApplauseJSObjectionBindingEntry alloc] initWithObject:metaClass];
    [_bindings setObject:entry forKey:key];    
}

- (void) bind:(id)instance toProtocol:(Protocol *)aProtocol {
    [self ensureInstance: instance conformsTo: aProtocol];
    NSString *key = [self protocolKey:aProtocol];
    ApplauseJSObjectionBindingEntry *entry = [[ApplauseJSObjectionBindingEntry alloc] initWithObject:instance];
    [_bindings setObject:entry forKey:key];  
}

- (void) bind:(id)instance toClass:(Class)aClass  {
    NSString *key = NSStringFromClass(aClass);
    ApplauseJSObjectionBindingEntry *entry = [[ApplauseJSObjectionBindingEntry alloc] initWithObject:instance];
    [_bindings setObject:entry forKey:key];
}

- (void)bindProvider:(id<ApplauseJSObjectionProvider>)provider toClass:(Class)aClass {
    [self bindProvider:provider toClass:aClass inScope:ApplauseJSObjectionScopeNormal];
}

- (void)bindProvider:(id<ApplauseJSObjectionProvider>)provider toProtocol:(Protocol *)aProtocol {
    [self bindProvider:provider toProtocol:aProtocol inScope:ApplauseJSObjectionScopeNormal];
}

- (void)bindProvider:(id <ApplauseJSObjectionProvider>)provider toClass:(Class)aClass inScope:(ApplauseJSObjectionScope)scope {
    NSString *key = NSStringFromClass(aClass);
    ApplauseJSObjectionProviderEntry *entry = [[ApplauseJSObjectionProviderEntry alloc] initWithProvider:provider lifeCycle:scope];
    [_bindings setObject:entry forKey:key];
}

- (void)bindProvider:(id <ApplauseJSObjectionProvider>)provider toProtocol:(Protocol *)aProtocol inScope:(ApplauseJSObjectionScope)scope {
    NSString *key = [self protocolKey:aProtocol];
    ApplauseJSObjectionProviderEntry *entry = [[ApplauseJSObjectionProviderEntry alloc] initWithProvider:provider lifeCycle:scope];
    [_bindings setObject:entry forKey:key];
}

- (void)bindClass:(Class)aClass toProtocol:(Protocol *)aProtocol {

    __ApplauseJSClassProvider *provider = [[__ApplauseJSClassProvider alloc] initWithClass:aClass];
    [self bindProvider:provider toProtocol:aProtocol];
}

- (void)bindClass:(Class)aClass toClass:(Class)toClass {
    __ApplauseJSClassProvider *provider = [[__ApplauseJSClassProvider alloc] initWithClass:aClass];
    [self bindProvider:provider toClass:toClass];
}


- (void)bindBlock:(id (^)(ApplauseJSObjectionInjector *context))block toClass:(Class)aClass {
    [self bindBlock:block toClass:aClass inScope:ApplauseJSObjectionScopeNormal];
}

- (void)bindBlock:(id (^)(ApplauseJSObjectionInjector *context))block toProtocol:(Protocol *)aProtocol {
    [self bindBlock:block toProtocol:aProtocol inScope:ApplauseJSObjectionScopeNormal];
}

- (void)bindBlock:(id (^)(ApplauseJSObjectionInjector *))block toClass:(Class)aClass inScope:(ApplauseJSObjectionScope)scope {
    NSString *key = NSStringFromClass(aClass);
    ApplauseJSObjectionProviderEntry *entry = [[ApplauseJSObjectionProviderEntry alloc] initWithBlock:block lifeCycle:scope];
    [_bindings setObject:entry forKey:key];
}

- (void)bindBlock:(id (^)(ApplauseJSObjectionInjector *))block toProtocol:(Protocol *)aProtocol inScope:(ApplauseJSObjectionScope)scope {
    NSString *key = [self protocolKey:aProtocol];
    ApplauseJSObjectionProviderEntry *entry = [[ApplauseJSObjectionProviderEntry alloc] initWithBlock:block lifeCycle: scope];
    [_bindings setObject:entry forKey:key];
}

- (void)bindClass:(Class)aClass inScope:(ApplauseJSObjectionScope)scope {
    [_bindings setObject:[ApplauseJSObjectionInjectorEntry entryWithClass:aClass scope:scope] forKey:NSStringFromClass(aClass)];
}

- (void) registerEagerSingleton:(Class)aClass  {
    [_eagerSingletons addObject:NSStringFromClass(aClass)];
}

- (BOOL)hasBindingForClass:(Class)aClass {
  return [_bindings objectForKey:NSStringFromClass(aClass)] != nil;
}

- (BOOL)hasBindingForProtocol:(Protocol *)protocol {
  return [_bindings objectForKey:[self protocolKey:protocol]] != nil;
}

- (void) configure {
}


#pragma mark Private
#pragma mark -

- (void)ensureInstance:(id)instance conformsTo:(Protocol *)aProtocol {
      if (![instance conformsToProtocol:aProtocol]) {
            @throw [NSException exceptionWithName:@"JSObjectionException" 
                                           reason:[NSString stringWithFormat:@"Instance does not conform to the %@ protocol", NSStringFromProtocol(aProtocol)] 
                                         userInfo:nil];
      }  
}

- (NSString *)protocolKey:(Protocol *)aProtocol {
    return [NSString stringWithFormat:@"<%@>", NSStringFromProtocol(aProtocol)]; 
}

@end