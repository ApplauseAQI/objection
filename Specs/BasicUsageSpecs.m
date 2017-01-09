#import "SpecHelper.h"
#import "Fixtures.h"
#import "InitializerFixtures.h"

QuickSpecBegin(BasicUsageSpecs)

beforeEach(^{
      ApplauseJSObjectionInjector *injector = [ApplauseJSObjection createInjector];
      [ApplauseJSObjection setDefaultInjector:injector];
});

it(@"correctly builds a registered object", ^{
    id engine = [[ApplauseJSObjection defaultInjector] getObject:[Engine class]];
      
    assertThat(engine, isNot(nilValue()));
});

it(@"will auto register a class if it is not explicitly registered", ^{
    UnregisteredCar *unregisteredCar = [[ApplauseJSObjection defaultInjector] getObject:[UnregisteredCar class]];
    assertThat(unregisteredCar, is(notNilValue()));
    assertThat(unregisteredCar.engine, is(notNilValue()));
});

it(@"correctly builds and object with dependencies", ^{
    Car *car = [[ApplauseJSObjection defaultInjector] getObject:[Car class]];

    assertThat(car, isNot(nilValue()));

    assertThat(car.engine, isNot(nilValue()));
    assertThat(car.engine, is(instanceOf([Engine class])));

    assertThat(car.brakes, isNot(nilValue()));
    assertThat(car.brakes, is(instanceOf([Brakes class])));
});

it(@"correctly builds objects with selector dependencies", ^{
    UnstoppableCar *car = [[ApplauseJSObjection defaultInjector] getObject:[UnstoppableCar class]];

    assertThat(car.engine, is(instanceOf([Engine class])));
});

it(@"will inject dependencies into properties of an existing instance", ^{
    Car *car = [[Car alloc] init];

    assertThat(car.engine, is(nilValue()));
    assertThat(car.brakes, is(nilValue()));

    [[ApplauseJSObjection defaultInjector] injectDependencies:car];

    assertThat(car.engine, isNot(nilValue()));
    assertThat(car.engine, is(instanceOf([Engine class])));

    assertThat(car.brakes, isNot(nilValue()));
    assertThat(car.brakes, is(instanceOf([Brakes class])));
});

it(@"calls awakeFromObjection when injecting dependencies into properties of an existing instance", ^{
    Car *car = [[Car alloc] init];
    
    [[ApplauseJSObjection defaultInjector] injectDependencies:car];

    assertThatBool([car awake], isTrue());
    assertThatBool([car.engine awake], isTrue());
});

it(@"defaults to returning a new instance", ^{
      id thomas = [[ApplauseJSObjection defaultInjector] getObject:[Engine class]];
      id gordan = [[ApplauseJSObjection defaultInjector] getObject:[Engine class]];
      
      assertThat(thomas, isNot(sameInstance(gordan)));
});

it(@"supports the subscript operator", ^{
    Car *car = [ApplauseJSObjection defaultInjector][[Car class]];
    
    assertThat(car, isNot(nilValue()));
    assertThat(car.engine, is(instanceOf([Engine class])));
});

it(@"will return the same instance if it is registered as a singleton", ^{
      id carFactory1 = [[ApplauseJSObjection defaultInjector] getObject:[CarFactory class]];
      id carFactory2 = [[ApplauseJSObjection defaultInjector] getObject:[CarFactory class]];
      
      assertThat(carFactory1, isNot(nilValue()));
      assertThat(carFactory1, is(sameInstance(carFactory2)));
});

it(@"ensures that singletons are properly registered even if they have not been referenced", ^{
      // Ensure that the class is initialized before attempting to retrieve it.  
      id holder1 = [[ApplauseJSObjection defaultInjector] getObject:[SingletonItemHolder class]];
      id holder2 = [[ApplauseJSObjection defaultInjector] getObject:[SingletonItemHolder class]];
      
      assertThat([holder1 singletonItem], is(sameInstance([holder2 singletonItem])));
});

it(@"will not return the same instance per injector if object is a singleton", ^{
      id carFactory1 = [[ApplauseJSObjection defaultInjector] getObject:[CarFactory class]];
      id carFactory2 = [[ApplauseJSObjection createInjector] getObject:[CarFactory class]];
      assertThat(carFactory1, isNot(sameInstance(carFactory2)));
});

it(@"returns nil if the class is nil", ^{
    assertThat([[ApplauseJSObjection defaultInjector] getObject:nil], is(nilValue()));
});

it(@"doesn't blow up if a nil class is passed into register", ^{
    [ApplauseJSObjection registerClass:nil scope:ApplauseJSObjectionScopeSingleton];
});

it(@"calls awakeFromObjection when an object has been constructed", ^{
      id engine = [[ApplauseJSObjection defaultInjector] getObject:[Engine class]];
      id car = [[ApplauseJSObjection defaultInjector] getObject:[Car class]];

      assertThatBool([engine awake], isTrue());
      assertThatBool([car awake], isTrue());
});


describe(@"object factory", ^{
    it(@"injector returns a ApplauseJSObjectFactory for the given injector context", ^{
        ApplauseJSObjectionInjector *injector1 = [ApplauseJSObjection createInjector];
        ApplauseJSObjectionInjector *injector2 = [ApplauseJSObjection defaultInjector];
        
        JSObjectFactoryHolder *holder1 = [injector1 getObject:[JSObjectFactoryHolder class]];
        JSObjectFactoryHolder *holder2 = [injector2 getObject:[JSObjectFactoryHolder class]];
        
        SingletonItem *item1 = holder1.objectFactory[[SingletonItem class]];
        SingletonItem *item2 = [holder2.objectFactory getObject:[SingletonItem class]];
        
        expect(item1).toNot(equal(item2));
    });
    
    it(@"can take variadic arguments and pass them along to the injector", ^{
        ApplauseJSObjectionInjector *injector = [ApplauseJSObjection defaultInjector];
        ApplauseJSObjectFactory *factory = [injector getObject:[ApplauseJSObjectFactory class]];
        
        ConfigurableCar *car = [factory getObjectWithArgs:[ConfigurableCar class], @"Model", @"Power", @"Year", nil];
        
        expect(car.model).to(equal(@"Model"));
        expect(car.horsePower).to(equal(@"Power"));
        expect(car.year).to(equal(@"Year"));
    });
});

describe(@"named instances", ^{
    it(@"are separate instances", ^{
        ShinyCar *shinyCar = [[ApplauseJSObjection defaultInjector] getObject:[ShinyCar class]];
        expect(shinyCar).toNot(equal(shinyCar.rightHeadlight));
    });
    
    it(@"can be used alongside non-named instances", ^{
        ShinyCar *shinyCar = [[ApplauseJSObjection defaultInjector] getObject:[ShinyCar class]];
        expect(shinyCar).toNot(beNil());
    });
    
    it(@"respect singleton scope", ^{
        BrightCar *brightCar = [[ApplauseJSObjection defaultInjector] getObject:[BrightCar class]];
        expect(brightCar.leftHighbeam).to(equal(brightCar.leftHighbeam));
    });
    
});

QuickSpecEnd