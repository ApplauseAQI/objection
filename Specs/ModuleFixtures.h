#import <Foundation/Foundation.h>
#import "Fixtures.h"
#import "SpecHelper.h"

extern BOOL gEagerSingletonHook;

@protocol MetaCar<NSObject>
- (id)manufacture;
@end

@protocol GearBox<NSObject>
- (void)shiftUp;
- (void)shiftDown;
@optional
- (void)engageClutch;
@end


@interface Car(Meta)
+ (id)manufacture;
@end


@interface AfterMarketGearBox : NSObject<GearBox>
@end

@interface EagerSingleton : NSObject
@end

@interface MyModule : ApplauseJSObjectionModule
{
  BOOL _instrumentInvalidEagerSingleton;
  BOOL _instrumentInvalidMetaClass;
}

@property(weak, nonatomic, readonly) Engine *engine;
@property(weak, nonatomic, readonly) id<GearBox> gearBox;
@property(nonatomic, assign) BOOL instrumentInvalidEagerSingleton;
@property (nonatomic, assign) BOOL instrumentInvalidMetaClass;

- (id)initWithEngine:(Engine *)engine andGearBox:(id<GearBox>)gearBox;
@end

@interface CarProvider : NSObject<ApplauseJSObjectionProvider>
@end

@interface GearBoxProvider : NSObject<ApplauseJSObjectionProvider>
@end

@interface ProviderModule : ApplauseJSObjectionModule
@end

@interface BlockModule : ApplauseJSObjectionModule

@property (nonatomic, assign) BOOL instrumentNilBlock;

@end

@interface CreditCardValidator : NSObject
@end

@protocol CreditCardProcessor <NSObject>
- (void)processNumber:(NSString *)number;
@end

@interface BaseCreditCardProcessor : NSObject<CreditCardProcessor>
@end

@interface VisaCCProcessor : BaseCreditCardProcessor<CreditCardProcessor> {
  CreditCardValidator *_validator;
}
- (id)initWithCreditCardNumber:(NSString *)aCCNumber;
@property (nonatomic, strong) NSString *CCNumber;
@property (nonatomic, strong) CreditCardValidator *validator;
@end

@interface FirstModule : ApplauseJSObjectionModule
@end

@interface SecondModule : ApplauseJSObjectionModule
@end

@interface ScopeModule : ApplauseJSObjectionModule

@end

@interface BlockScopeModule : ApplauseJSObjectionModule

@end

@interface ProviderScopeModule : ApplauseJSObjectionModule

@end

@interface BlinkerProvider : NSObject<ApplauseJSObjectionProvider>
@end

@interface NamedModule : ApplauseJSObjectionModule
- (id)initWithRightHeadlight:(Headlight*)rightHeadlight;
@end




