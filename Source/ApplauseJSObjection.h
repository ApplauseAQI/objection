#import <Foundation/Foundation.h>
#import "ApplauseJSObjectionInjector.h"
#import "ApplauseJSObjectionEntry.h"
#import "ApplauseJSObjectionUtils.h"

@interface ApplauseJSObjection : NSObject {
    
}

+ (ApplauseJSObjectionInjector *)createInjectorWithModules:(ApplauseJSObjectionModule *)first, ... NS_REQUIRES_NIL_TERMINATION;
+ (ApplauseJSObjectionInjector *)createInjectorWithModulesArray:(NSArray *)modules;
+ (ApplauseJSObjectionInjector *)createInjector:(ApplauseJSObjectionModule *)module;
+ (ApplauseJSObjectionInjector *)createInjector;
+ (void)registerClass:(Class)theClass scope:(ApplauseJSObjectionScope)scope;
+ (void)setDefaultInjector:(ApplauseJSObjectionInjector *)anInjector;
+ (ApplauseJSObjectionInjector *)defaultInjector;
+ (void)reset;
+ (ApplauseJSObjectionPropertyInfo)propertyForClass:(Class)theClass andProperty:(NSString *)propertyName;
+ (void)setPropertyReflector:(Class)reflector;
@end
