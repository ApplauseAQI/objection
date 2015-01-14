#import "InjectionErrorFixtures.h"
#import "ApplauseObjection.h"

@implementation UnsupportedPropertyObject
apl_objection_register(UnsupportedPropertyObject)
apl_objection_requires(@"myInteger")
@synthesize myInteger;

@end

@implementation BadPropertyObject
@synthesize someObject;
apl_objection_register(BadPropertyObject)
apl_objection_requires(@"badProperty")
@end

@implementation ReadOnlyPropertyObject
apl_objection_register(ReadOnlyPropertyObject)
apl_objection_requires(@"someObject")

@synthesize someObject=_someObject;
@end

