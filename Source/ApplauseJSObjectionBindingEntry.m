#import "ApplauseJSObjectionBindingEntry.h"

@interface ApplauseJSObjectionBindingEntry () {
  id _instance;
}

@end

@implementation ApplauseJSObjectionBindingEntry

- (instancetype)initWithObject:(id)theObject {
    if ((self = [super init])) {
        _instance = theObject;    
    }
    return self;
}

- (id)extractObject:(NSArray *)arguments {
    return _instance;
}

- (JSObjectionScope)lifeCycle {
    return ApplauseJSObjectionScopeSingleton;
}

- (void)dealloc {
     _instance = nil;
}

@end
