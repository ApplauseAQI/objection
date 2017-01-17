#import <Foundation/Foundation.h>
#import "ApplauseJSObjectionEntry.h"
#import "ApplauseJSObjectionModule.h"

@class ApplauseJSObjectionInjector;

@interface ApplauseJSObjectionProviderEntry : ApplauseJSObjectionEntry

- (id)initWithProvider:(id<ApplauseJSObjectionProvider>)theProvider lifeCycle:(ApplauseJSObjectionScope)theLifeCycle;
- (id)initWithBlock:(id(^)(ApplauseJSObjectionInjector *context))theBlock lifeCycle:(ApplauseJSObjectionScope)theLifeCycle;

@end
