#import <Foundation/Foundation.h>
#import "ApplauseJSObjectionEntry.h"

@interface ApplauseJSObjectionInjectorEntry : ApplauseJSObjectionEntry
{
    ApplauseJSObjectionScope _lifeCycle;
    id _storageCache;
}

@property (nonatomic, readonly) Class classEntry;

- (id)initWithClass:(Class)theClass lifeCycle:(ApplauseJSObjectionScope)theLifeCycle;
+ (id)entryWithClass:(Class)theClass scope:(ApplauseJSObjectionScope)theLifeCycle;
@end
