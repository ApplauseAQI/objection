#import <Foundation/Foundation.h>
#import "ApplauseJSObjectionEntry.h"

@interface ApplauseJSObjectionInjectorEntry : ApplauseJSObjectionEntry

@property (nonatomic, readonly) Class classEntry;

- (instancetype)initWithClass:(Class)theClass lifeCycle:(JSObjectionScope)theLifeCycle;
+ (instancetype)entryWithClass:(Class)theClass scope:(JSObjectionScope)theLifeCycle;

@end
