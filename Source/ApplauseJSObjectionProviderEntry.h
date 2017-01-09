#import <Foundation/Foundation.h>
#import "ApplauseJSObjectionEntry.h"
#import "ApplauseJSObjectionModule.h"

@class ApplauseJSObjectionInjector;

@interface ApplauseJSObjectionProviderEntry : ApplauseJSObjectionEntry

- (id)initWithProvider:(id<ApplauseJSObjectionProvider>)theProvider lifeCycle:(JSObjectionScope)theLifeCycle;
- (id)initWithBlock:(id(^)(ApplauseJSObjectionInjector *context))theBlock lifeCycle:(JSObjectionScope)theLifeCycle;

@end
