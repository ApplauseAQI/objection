#import "ApplauseJSObjectionBindingEntry.h"


@implementation ApplauseJSObjectionBindingEntry

- (id)initWithObject:(id)theObject {
    if ((self = [super init])) {
        _instance = theObject;    
    }
    return self;
}

- (id)extractObject:(NSArray *)arguments {
    return _instance;
}

- (ApplauseJSObjectionScope)lifeCycle {
    return ApplauseJSObjectionScopeSingleton;
}

- (void)dealloc {
     _instance = nil;
}

@end
