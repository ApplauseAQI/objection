#import <Foundation/Foundation.h>
#import "ApplauseJSObjectionEntry.h"

@class ApplauseJSObjectionInjector;

@protocol ApplauseJSObjectionProvider <NSObject>
- (id)provide:(ApplauseJSObjectionInjector *)context arguments:(NSArray *)arguments;
@end


@interface ApplauseJSObjectionModule : NSObject {
    NSMutableDictionary *_bindings;
    NSMutableSet *_eagerSingletons;
}

@property (nonatomic, readonly) NSDictionary *bindings;
@property (nonatomic, readonly) NSSet *eagerSingletons;

- (void)bind:(id)instance toClass:(Class)aClass;
- (void)bind:(id)instance toProtocol:(Protocol *)aProtocol;
- (void)bindMetaClass:(Class)metaClass toProtocol:(Protocol *)aProtocol;
- (void)bindProvider:(id<ApplauseJSObjectionProvider>)provider toClass:(Class)aClass;
- (void)bindProvider:(id<ApplauseJSObjectionProvider>)provider toProtocol:(Protocol *)aProtocol;
- (void)bindProvider:(id<ApplauseJSObjectionProvider>)provider toClass:(Class)aClass inScope:(ApplauseJSObjectionScope)scope;
- (void)bindProvider:(id<ApplauseJSObjectionProvider>)provider toProtocol:(Protocol *)aProtocol inScope:(ApplauseJSObjectionScope)scope;
- (void)bindClass:(Class)aClass toProtocol:(Protocol *)aProtocol;
- (void)bindClass:(Class)aClass toClass:(Class)toClass;
- (void)bindBlock:(id (^)(ApplauseJSObjectionInjector *context))block toClass:(Class)aClass;
- (void)bindBlock:(id (^)(ApplauseJSObjectionInjector *context))block toProtocol:(Protocol *)aProtocol;
- (void)bindBlock:(id (^)(ApplauseJSObjectionInjector *context))block toClass:(Class)aClass inScope:(ApplauseJSObjectionScope)scope;
- (void)bindBlock:(id (^)(ApplauseJSObjectionInjector *context))block toProtocol:(Protocol *)aProtocol inScope:(ApplauseJSObjectionScope)scope;
- (void)bindClass:(Class)aClass inScope:(ApplauseJSObjectionScope)scope;
- (void)registerEagerSingleton:(Class)aClass;
- (BOOL)hasBindingForClass:(Class)aClass;
- (BOOL)hasBindingForProtocol:(Protocol *)protocol;
- (void)configure;
@end