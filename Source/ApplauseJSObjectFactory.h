#import <Foundation/Foundation.h>

@class ApplauseJSObjectionInjector;

@interface ApplauseJSObjectFactory : NSObject

@property (nonatomic, readonly, weak) ApplauseJSObjectionInjector *injector;

- (instancetype)initWithInjector:(ApplauseJSObjectionInjector *)injector;
- (id)getObject:(id)classOrProtocol;
- (id)getObject:(id)classOrProtocol withArgumentList:(NSArray *)arguments;
- (id)getObject:(id)classOrProtocol initializer:(SEL)initializer withArgumentList:(NSArray *)arguments;
- (id)getObject:(id)classOrProtocol named:(NSString *)named withArgumentList:(NSArray *)arguments;
- (id)objectForKeyedSubscript: (id)key;
- (id)getObjectWithArgs:(id)classOrProtocol, ... NS_REQUIRES_NIL_TERMINATION;

@end
