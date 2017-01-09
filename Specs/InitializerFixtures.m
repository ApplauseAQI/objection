#import "InitializerFixtures.h"

@implementation Truck
apl_objection_register(Truck)
apl_objection_initializer(truck:, @"Chevy")

+ (id)truck: (NSString *)name {
    Truck *truck = [[self alloc] init];
    truck.name = name;
    return truck;    
}
@end

@implementation BadInitializer
apl_objection_register(BadInitializer)
apl_objection_initializer(initWithNonExistentInitializer)
@end

@implementation ViewController
apl_objection_register(ViewController)
apl_objection_requires(@"car")
apl_objection_initializer(initWithNibName:bundle:, @"MyNib")

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super init])) {
        self.nibName = nibNameOrNil;
        self.bundle = nibBundleOrNil;
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name {
    if ((self = [super init])) {
        self.name = name;
    }
    return self;
}
@end

@implementation ConfigurableCar
apl_objection_register(ConfigurableCar)
apl_objection_requires(@"engine")
apl_objection_initializer_sel(@selector(initWithModel:horsePower:andYear:))

@synthesize car = _car;
@synthesize engine = _engine;

@synthesize horsePower = _horsePower;
@synthesize model = _model;
@synthesize year = _year;

- (id)initWithModel:(NSString *)model horsePower:(NSNumber *)horsePower andYear:(NSNumber *)year {
    if ((self = [super init])) {
        self.model = model;
        self.horsePower = horsePower;
        self.year = year;
    }
    return self;
}

@end

@implementation FilterInitInitializer
apl_objection_initializer(init)

@end