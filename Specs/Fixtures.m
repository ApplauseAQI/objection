#import "Fixtures.h"
#import "ApplauseObjection.h"
#import "CircularDependencyFixtures.h"

@implementation Engine
apl_objection_register(Engine)
@synthesize awake;

- (void) awakeFromObjection {
	awake = YES;  
}
@end

@implementation Brakes

@end


@implementation Car
apl_objection_register(Car)

@synthesize engine, brakes, awake;

- (void)awakeFromObjection {
  awake = YES;
}

apl_objection_requires(@"engine", @"brakes")
@end

@implementation UnregisteredCar
apl_objection_requires(@"engine")
@synthesize engine;
@end

@implementation FiveSpeedCar
apl_objection_register(FiveSpeedCar)

@synthesize gearBox;

apl_objection_requires(@"gearBox")
@end

@implementation SixSpeedCar
apl_objection_register(SixSpeedCar)
@synthesize gearBox;
@end

@implementation CarFactory
apl_objection_register_singleton(CarFactory)
@end

@implementation SingletonItemHolder
@synthesize singletonItem;
apl_objection_register(SingletonItemHolder)
apl_objection_requires(@"singletonItem")
@end

@implementation SingletonItem
apl_objection_register_singleton(SingletonItem)
@end

@implementation JSObjectFactoryHolder
apl_objection_register_singleton(JSObjectFactoryHolder)
apl_objection_requires(@"objectFactory")

@synthesize objectFactory;
@end

@implementation SingletonFoo
apl_objection_register_singleton(SingletonFoo)
apl_objection_requires(@"bar")

@synthesize bar;
@end

@implementation UnstoppableCar
apl_objection_requires_sel(@selector(engine))
@end
