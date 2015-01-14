#import <Foundation/Foundation.h>
#import "ApplauseJSObjectionEntry.h"
#import "ApplauseJSObjectionModule.h"

@class ApplauseJSObjectionInjector;

@interface ApplauseJSObjectionProviderEntry : ApplauseJSObjectionEntry
{
    id<ApplauseJSObjectionProvider> _provider;
    id(^_block)(ApplauseJSObjectionInjector *context);
    ApplauseJSObjectionScope _lifeCycle;
    id _storageCache;
}

- (id)initWithProvider:(id<ApplauseJSObjectionProvider>)theProvider lifeCycle:(ApplauseJSObjectionScope)theLifeCycle;
- (id)initWithBlock:(id(^)(ApplauseJSObjectionInjector *context))theBlock lifeCycle:(ApplauseJSObjectionScope)theLifeCycle;
@end
