#import "ApplauseObjection.h"
#import "CircularDependencyFixtures.h"
#import "Fixtures.h"

@implementation SingletonBar
apl_objection_register_singleton(SingletonBar)
apl_objection_requires(@"foo")

@synthesize foo;
@end