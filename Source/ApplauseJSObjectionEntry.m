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

- (JSObjectionScope)lifeCycle {
    return ApplauseJSObjectionScopeNone;
}
@end
