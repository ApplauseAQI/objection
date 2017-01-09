#import "ApplauseJSObjectionInjectorEntry.h"
#import "ApplauseJSObjection.h"
#import "ApplauseJSObjectionUtils.h"
#import "NSObject+ApplauseObjection.h"

@interface ApplauseJSObjectionInjectorEntry() {
  JSObjectionScope _lifeCycle;
  id _storageCache;
}

- (id)buildObject:(NSArray *)arguments initializer:(SEL)initializer;
- (id)argumentsForObject:(NSArray *)givenArguments;
- (SEL)initializerForObject;

@end


@implementation ApplauseJSObjectionInjectorEntry

@synthesize lifeCycle = _lifeCycle;
@synthesize classEntry = _classEntry;


#pragma mark - Instance Methods

- (instancetype)initWithClass:(Class)theClass lifeCycle:(JSObjectionScope)theLifeCycle {
  if ((self = [super init])) {
    _lifeCycle = theLifeCycle;
    _classEntry = theClass;
    _storageCache = nil;
  }
  
  return self;
}

- (instancetype) extractObject:(NSArray *)arguments initializer:(SEL)initializer {
    if (self.lifeCycle == ApplauseJSObjectionScopeNormal || !_storageCache) {
        return [self buildObject:arguments initializer: initializer];
    }
    return _storageCache;
}

- (instancetype)extractObject:(NSArray *)arguments {
    return [self extractObject:arguments initializer:nil];
}

- (void)dealloc  {
   _storageCache = nil;
}


#pragma mark - Private Methods

- (id)buildObject:(NSArray *)arguments initializer: (SEL) initializer {
    
    id objectUnderConstruction = nil;
    
    if(initializer != nil) {
        objectUnderConstruction = ApplauseJSObjectionUtils.buildObjectWithInitializer(self.classEntry, initializer, arguments);
    } else if ([self.classEntry respondsToSelector:@selector(objectionInitializer)]) {
        objectUnderConstruction = ApplauseJSObjectionUtils.buildObjectWithInitializer(self.classEntry, [self initializerForObject], [self argumentsForObject:arguments]);
    } else {
        objectUnderConstruction = [[self.classEntry alloc] init];
    }

    if (self.lifeCycle == ApplauseJSObjectionScopeSingleton) {
        _storageCache = objectUnderConstruction;
    }
    
    ApplauseJSObjectionUtils.injectDependenciesIntoProperties(self.injector, self.classEntry, objectUnderConstruction);
    
    return objectUnderConstruction;
}

- (SEL)initializerForObject {
    return NSSelectorFromString([[self.classEntry performSelector:@selector(objectionInitializer)] objectForKey:ApplauseJSObjectionInitializerKey]);
}

- (NSArray *)argumentsForObject:(NSArray *)givenArguments {
    return givenArguments.count > 0 ? givenArguments : [[self.classEntry performSelector:@selector(objectionInitializer)] objectForKey:ApplauseJSObjectionDefaultArgumentsKey];
}


#pragma mark - Class Methods

+ (id)entryWithClass:(Class)theClass scope:(JSObjectionScope)theLifeCycle  {
    return [[ApplauseJSObjectionInjectorEntry alloc] initWithClass:theClass lifeCycle:theLifeCycle];
}

+ (id)entryWithEntry:(ApplauseJSObjectionInjectorEntry *)entry {
    return [[ApplauseJSObjectionInjectorEntry alloc] initWithClass:entry.classEntry lifeCycle:entry.lifeCycle];
}
@end
