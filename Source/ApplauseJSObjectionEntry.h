#import <Foundation/Foundation.h>

typedef enum {
      ApplauseJSObjectionScopeNone = -1,
      ApplauseJSObjectionScopeNormal,
      ApplauseJSObjectionScopeSingleton
} ApplauseJSObjectionScope;


@class ApplauseJSObjectionInjector, ApplauseJSObjectionEntry;

@protocol ApplauseJSObjectionEntry <NSObject>
@property (nonatomic, readonly) ApplauseJSObjectionScope lifeCycle;
@property (nonatomic, assign) ApplauseJSObjectionInjector *injector;
- (id)extractObject:(NSArray *)arguments;
+ (id)entryWithEntry:(ApplauseJSObjectionEntry *)entry;
@end

@interface ApplauseJSObjectionEntry : NSObject<ApplauseJSObjectionEntry>
{
}

@end
