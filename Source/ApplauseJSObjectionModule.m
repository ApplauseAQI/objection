#import "ApplauseJSObjectionModule.h"
#import "ApplauseJSObjectionBindingEntry.h"
#import "ApplauseJSObjectionInjectorEntry.h"
#import <objc/runtime.h>
#import "ApplauseJSObjectionProviderEntry.h"
#import "ApplauseJSObjectionInjector.h"

@interface __ApplauseJSClassProvider : NSObject<ApplauseJSObjectionProvider> {
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


@interface ApplauseJSObjectionModule() {
  NSMutableDictionary *_bindings;
  NSMutableSet *_eagerSingletons;
}

- (NSString *)classKey:(Class)class withName:(NSString*)name;
- (NSString *)protocolKey:(Protocol *)aProtocol withName:(NSString*)name;
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
        @throw [NSException exceptionWithName:@"ApplauseJSObjectionException"
                                       reason:[NSString stringWithFormat:@"\"%@\" can not be bound to the protocol \"%@\" because it is not a meta class", metaClass, NSStringFromProtocol(aProtocol)]
                                     userInfo:nil];
    }
    NSString *key = [self protocolKey:aProtocol withName:nil];
    ApplauseJSObjectionBindingEntry *entry = [[ApplauseJSObjectionBindingEntry alloc] initWithObject:metaClass];
    [_bindings setObject:entry forKey:key];
}

- (void) bind:(id)instance toProtocol:(Protocol *)aProtocol {
    [self bind:instance toProtocol:aProtocol named:nil];
}

- (void)bind:(id)instance toProtocol:(Protocol *)aProtocol named:(NSString *)name {
    [self ensureInstance: instance conformsTo: aProtocol];
    NSString *key = [self protocolKey:aProtocol withName:name];
    ApplauseJSObjectionBindingEntry *entry = [[ApplauseJSObjectionBindingEntry alloc] initWithObject:instance];
    [_bindings setObject:entry forKey:key];
}

- (void) bind:(id)instance toClass:(Class)aClass  {
    [self bind:instance toClass:aClass named:nil];
}

- (void)bind:(id)instance toClass:(Class)aClass named:(NSString *)name {
    NSString *key = [self classKey:aClass withName:name];
    ApplauseJSObjectionBindingEntry *entry = [[ApplauseJSObjectionBindingEntry alloc] initWithObject:instance];
    [_bindings setObject:entry forKey:key];
}

- (void)bindProvider:(id<ApplauseJSObjectionProvider>)provider toClass:(Class)aClass {
    [self bindProvider:provider toClass:aClass named:nil];
}

- (void)bindProvider:(id <ApplauseJSObjectionProvider>)provider toClass:(Class)aClass named:(NSString *)name {
    [self bindProvider:provider toClass:aClass inScope:ApplauseJSObjectionScopeNormal named:name];
}

- (void)bindProvider:(id<ApplauseJSObjectionProvider>)provider toProtocol:(Protocol *)aProtocol {
    [self bindProvider:provider toProtocol:aProtocol named:nil];
}

- (void)bindProvider:(id <ApplauseJSObjectionProvider>)provider toProtocol:(Protocol *)aProtocol named:(NSString *)name {
    [self bindProvider:provider toProtocol:aProtocol inScope:ApplauseJSObjectionScopeNormal named:name];
}

- (void)bindProvider:(id <ApplauseJSObjectionProvider>)provider toClass:(Class)aClass inScope:(ApplauseJSObjectionScope)scope {
    [self bindProvider:provider toClass:aClass inScope:scope named:nil];
}

- (void)bindProvider:(id <ApplauseJSObjectionProvider>)provider toClass:(Class)aClass inScope:(ApplauseJSObjectionScope)scope
        named:(NSString *)name {
    NSString *key = [self classKey:aClass withName:name];
    ApplauseJSObjectionProviderEntry *entry = [[ApplauseJSObjectionProviderEntry alloc] initWithProvider:provider lifeCycle:scope];
    [_bindings setObject:entry forKey:key];
}

- (void)bindProvider:(id <ApplauseJSObjectionProvider>)provider toProtocol:(Protocol *)aProtocol inScope:(ApplauseJSObjectionScope)scope {
    [self bindProvider:provider toProtocol:aProtocol inScope:scope named:nil];
}

- (void)bindProvider:(id <ApplauseJSObjectionProvider>)provider toProtocol:(Protocol *)aProtocol inScope:(ApplauseJSObjectionScope)scope
        named:(NSString *)name {
    NSString *key = [self protocolKey:aProtocol withName:name];
    ApplauseJSObjectionProviderEntry *entry = [[ApplauseJSObjectionProviderEntry alloc] initWithProvider:provider lifeCycle:scope];
    [_bindings setObject:entry forKey:key];
}

- (void)bindClass:(Class)aClass toProtocol:(Protocol *)aProtocol {
   [self bindClass:aClass toProtocol:aProtocol named:nil];
}

- (void)bindClass:(Class)aClass toProtocol:(Protocol *)aProtocol named:(NSString*)name {
    [self bindClass:aClass toProtocol:aProtocol inScope:ApplauseJSObjectionScopeNormal named:name];
}

- (void)bindClass:(Class)aClass toProtocol:(Protocol *)aProtocol inScope:(ApplauseJSObjectionScope)scope named:(NSString*)name{
    __ApplauseJSClassProvider *provider = [[__ApplauseJSClassProvider alloc] initWithClass:aClass];
    [self bindProvider:provider toProtocol:aProtocol inScope:scope named:name];
}

- (void)bindClass:(Class)aClass toClass:(Class)toClass {
    [self bindClass:aClass toClass:toClass named:nil];
}

- (void)bindClass:(Class)aClass toClass:(Class)toClass named:(NSString*)name {
    [self bindClass:aClass toClass:toClass inScope:ApplauseJSObjectionScopeNormal named:name];
}

- (void)bindClass:(Class)aClass toClass:(Class)toClass inScope:(ApplauseJSObjectionScope)scope named:(NSString*)name {
    __ApplauseJSClassProvider *provider = [[__ApplauseJSClassProvider alloc] initWithClass:aClass];
    [self bindProvider:provider toClass:toClass inScope:scope named:name];
}

- (void)bindBlock:(id (^)(ApplauseJSObjectionInjector *context))block toClass:(Class)aClass {
    [self bindBlock:block toClass:aClass named:nil];
}

- (void)bindBlock:(id (^)(ApplauseJSObjectionInjector *context))block toClass:(Class)aClass named:(NSString *)name {
    [self bindBlock:block toClass:aClass inScope:ApplauseJSObjectionScopeNormal named:name];
}

- (void)bindBlock:(id (^)(ApplauseJSObjectionInjector *context))block toProtocol:(Protocol *)aProtocol {
    [self bindBlock:block toProtocol:aProtocol named:nil];
}

- (void)bindBlock:(id (^)(ApplauseJSObjectionInjector *context))block toProtocol:(Protocol *)aProtocol named:(NSString *)name {
    [self bindBlock:block toProtocol:aProtocol inScope:ApplauseJSObjectionScopeNormal named:name];
}

- (void)bindBlock:(id (^)(ApplauseJSObjectionInjector *))block toClass:(Class)aClass inScope:(ApplauseJSObjectionScope)scope {
    [self bindBlock:block toClass:aClass inScope:scope named:nil];
}

- (void)bindBlock:(id (^)(ApplauseJSObjectionInjector *context))block toClass:(Class)aClass inScope:(ApplauseJSObjectionScope)scope
        named:(NSString *)name {
    NSString *key = [self classKey:aClass withName:name];
    ApplauseJSObjectionProviderEntry *entry = [[ApplauseJSObjectionProviderEntry alloc] initWithBlock:block lifeCycle:scope];
    [_bindings setObject:entry forKey:key];
}

- (void)bindBlock:(id (^)(ApplauseJSObjectionInjector *))block toProtocol:(Protocol *)aProtocol inScope:(ApplauseJSObjectionScope)scope {
    [self bindBlock:block toProtocol:aProtocol inScope:scope named:nil];
}

- (void)bindBlock:(id (^)(ApplauseJSObjectionInjector *context))block toProtocol:(Protocol *)aProtocol
        inScope:(ApplauseJSObjectionScope)scope named:(NSString *)name {
    NSString *key = [self protocolKey:aProtocol withName:name];
    ApplauseJSObjectionProviderEntry *entry = [[ApplauseJSObjectionProviderEntry alloc] initWithBlock:block lifeCycle: scope];
    [_bindings setObject:entry forKey:key];
}

- (void)bindClass:(Class)aClass inScope:(ApplauseJSObjectionScope)scope {
    [_bindings setObject:[ApplauseJSObjectionInjectorEntry entryWithClass:aClass scope:scope] forKey:[self classKey:aClass withName:nil]];
}

- (void) registerEagerSingleton:(Class)aClass  {
    [_eagerSingletons addObject:[self classKey:aClass withName:nil]];
}

- (BOOL)hasBindingForClass:(Class)aClass {
    return [self hasBindingForClass:aClass withName:nil];
}

- (BOOL)hasBindingForClass:(Class)aClass withName:(NSString*)name {
    return [_bindings objectForKey:[self classKey:aClass withName:name]] != nil;
}

- (BOOL)hasBindingForProtocol:(Protocol *)protocol {
   return [self hasBindingForProtocol:protocol withName:nil];
}

- (BOOL)hasBindingForProtocol:(Protocol *)protocol withName:(NSString*)name {
    return [_bindings objectForKey:[self protocolKey:protocol withName:name]] != nil;
}

- (void) configure {
}


#pragma mark - Private

- (void)ensureInstance:(id)instance conformsTo:(Protocol *)aProtocol {
    if (![instance conformsToProtocol:aProtocol]) {
        @throw [NSException exceptionWithName:@"ApplauseJSObjectionException"
                                       reason:[NSString stringWithFormat:@"Instance does not conform to the %@ protocol", NSStringFromProtocol(aProtocol)]
                                     userInfo:nil];
    }
}

- (NSString *)classKey:(Class) aClass withName:(NSString*)name {
    return [NSString stringWithFormat:@"%@%@%@", NSStringFromClass(aClass), name ? @":" : @"", name ? name : @""];
}

- (NSString *)protocolKey:(Protocol *)aProtocol withName:(NSString*)name{
    return [NSString stringWithFormat:@"<%@>%@%@", NSStringFromProtocol(aProtocol), name ? @":" : @"", name ? name : @""];
}

@end
