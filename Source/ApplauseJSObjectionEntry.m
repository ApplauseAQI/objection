#import "ApplauseJSObjectionEntry.h"

@implementation ApplauseJSObjectionEntry
@synthesize injector;
@dynamic lifeCycle;

- (id)extractObject:(NSArray *)arguments {
    return nil;
}

+ (id)entryWithEntry:(ApplauseJSObjectionEntry *)entry {
    return entry;
}

- (ApplauseJSObjectionScope)lifeCycle {
    return ApplauseJSObjectionScopeNone;
}
@end
