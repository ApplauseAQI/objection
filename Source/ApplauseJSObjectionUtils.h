#import <Foundation/Foundation.h>
#import <objc/runtime.h>

extern NSString *const ApplauseJSObjectionInitializerKey;
extern NSString *const ApplauseJSObjectionDefaultArgumentsKey;

typedef enum {
    ApplauseJSObjectionTypeClass,
    ApplauseJSObjectionTypeProtocol
} ApplauseJSObjectionType;


typedef struct ApplauseJSObjectionPropertyInfo {
    __unsafe_unretained id value;
    ApplauseJSObjectionType type;
} ApplauseJSObjectionPropertyInfo;


@protocol ApplauseJSObjectionPropertyReflector <NSObject>

- (ApplauseJSObjectionPropertyInfo)propertyForClass:(Class)theClass andProperty:(NSString *)propertyName;

@end


@class ApplauseJSObjectionInjector;

extern const struct ApplauseJSObjectionUtils {
    ApplauseJSObjectionPropertyInfo (*findClassOrProtocolForProperty)(objc_property_t property);
    objc_property_t (*propertyForClass)(Class klass, NSString *propertyName);
    NSSet* (*buildDependenciesForClass)(Class klass, NSSet *requirements);
    NSDictionary* (*buildNamedDependenciesForClass)(Class klass, NSDictionary *namedRequirements);
    NSDictionary* (*buildInitializer)(SEL selector, NSArray *arguments);
    NSArray* (*transformVariadicArgsToArray)(va_list va_arguments);
    id (*buildObjectWithInitializer)(Class klass, SEL initializer, NSArray *arguments);
    void (*injectDependenciesIntoProperties)(ApplauseJSObjectionInjector *injector, Class klass, id object);
} ApplauseJSObjectionUtils;
