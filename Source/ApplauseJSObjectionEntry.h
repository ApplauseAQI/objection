#import <Foundation/Foundation.h>

typedef enum {
    ApplauseJSObjectionScopeNone = -1,
    ApplauseJSObjectionScopeNormal,
    ApplauseJSObjectionScopeSingleton
} JSObjectionScope;


@class ApplauseJSObjectionInjector, ApplauseJSObjectionEntry;

@protocol ApplauseJSObjectionEntry<NSObject>

@property (nonatomic, readonly) JSObjectionScope lifeCycle;
@property (nonatomic, assign) ApplauseJSObjectionInjector *injector;

@required
- (id)extractObject:(NSArray *)arguments;
+ (id)entryWithEntry:(ApplauseJSObjectionEntry *)entry;
@optional
-(id) extractObject:(NSArray *)arguments initializer: (SEL)initializer;

@end


@interface ApplauseJSObjectionEntry : NSObject<ApplauseJSObjectionEntry>

@end
