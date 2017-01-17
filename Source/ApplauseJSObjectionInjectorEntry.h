#import <Foundation/Foundation.h>
#import "ApplauseJSObjectionEntry.h"

@interface ApplauseJSObjectionInjectorEntry : ApplauseJSObjectionEntry

@property (nonatomic, readonly) Class classEntry;

- (instancetype)initWithClass:(Class)theClass lifeCycle:(ApplauseJSObjectionScope)theLifeCycle;
+ (instancetype)entryWithClass:(Class)theClass scope:(ApplauseJSObjectionScope)theLifeCycle;

@end
