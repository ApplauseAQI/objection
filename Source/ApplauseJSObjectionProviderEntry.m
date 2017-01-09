#import "ApplauseJSObjectionProviderEntry.h"

@interface ApplauseJSObjectionProviderEntry () {
  id<ApplauseJSObjectionProvider> _provider;
  id(^_block)(ApplauseJSObjectionInjector *context);
  JSObjectionScope _lifeCycle;
  id _storageCache;
}

@end

@implementation ApplauseJSObjectionProviderEntry
@synthesize lifeCycle = _lifeCycle;

- (id)initWithProvider:(id<ApplauseJSObjectionProvider>)theProvider lifeCycle:(JSObjectionScope)theLifeCycle {
    if ((self = [super init])) {
        _provider = theProvider;
        _lifeCycle = theLifeCycle;
        _storageCache = nil;
    }

    return self;
}

- (id)initWithBlock:(id(^)(ApplauseJSObjectionInjector *context))theBlock lifeCycle:(JSObjectionScope)theLifeCycle {
    if ((self = [super init])) {
        _block = [theBlock copy];
        _lifeCycle = theLifeCycle;
        _storageCache = nil;
    }

    return self;  
}

- (id)extractObject:(NSArray *)arguments {
    if (self.lifeCycle == ApplauseJSObjectionScopeNormal || !_storageCache) {
        return [self buildObject:arguments];
    }

    return _storageCache;
}

- (void)dealloc {
    _storageCache = nil;
}

- (id)buildObject:(NSArray *)arguments {
    id objectUnderConstruction = nil;
    if (_block) {
        objectUnderConstruction = _block(self.injector);
    }
    else {
        objectUnderConstruction = [_provider provide:self.injector arguments:arguments];
    }
    if (self.lifeCycle == ApplauseJSObjectionScopeSingleton) {
        _storageCache = objectUnderConstruction;
    }
    return objectUnderConstruction;
}

@end
