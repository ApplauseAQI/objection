#import "ApplauseJSObjectionInjectorEntry.h"
#import "ApplauseJSObjection.h"
#import "ApplauseJSObjectionUtils.h"
#import "NSObject+ApplauseObjection.h"

@interface ApplauseJSObjectionInjectorEntry ()
- (id)buildObject:(NSArray *)arguments;
- (id)argumentsForObject:(NSArray *)givenArguments;
- (SEL)initializerForObject;
@end


@implementation ApplauseJSObjectionInjectorEntry
@synthesize lifeCycle = _lifeCycle; 
@synthesize classEntry = _classEntry;

#pragma mark Instance Methods
#pragma mark -

- (id)initWithClass:(Class)theClass lifeCycle:(ApplauseJSObjectionScope)theLifeCycle
{
  if ((self = [super init])) {
    _lifeCycle = theLifeCycle;
    _classEntry = theClass;
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

- (void)dealloc 
{
   _storageCache = nil;
}


#pragma mark -
#pragma mark Private Methods

- (id)buildObject:(NSArray *)arguments {
    
    id objectUnderConstruction = nil;
    if ([self.classEntry respondsToSelector:@selector(objectionInitializer)]) {
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

#pragma mark Class Methods
#pragma mark -

+ (id)entryWithClass:(Class)theClass scope:(ApplauseJSObjectionScope)theLifeCycle  {
    return [[ApplauseJSObjectionInjectorEntry alloc] initWithClass:theClass lifeCycle:theLifeCycle];
}

+ (id)entryWithEntry:(ApplauseJSObjectionInjectorEntry *)entry {
    return [[ApplauseJSObjectionInjectorEntry alloc] initWithClass:entry.classEntry lifeCycle:entry.lifeCycle];
}
@end
