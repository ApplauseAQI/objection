#import "ApplauseJSObjectionRuntimePropertyReflector.h"

@implementation ApplauseJSObjectionRuntimePropertyReflector

- (ApplauseJSObjectionPropertyInfo)propertyForClass:(Class)theClass andProperty:(NSString *)propertyName {
    objc_property_t property = ApplauseJSObjectionUtils.propertyForClass(theClass, propertyName);
    return ApplauseJSObjectionUtils.findClassOrProtocolForProperty(property);
}

@end
