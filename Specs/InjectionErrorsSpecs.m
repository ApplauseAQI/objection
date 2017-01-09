#import "SpecHelper.h"
#import "InjectionErrorFixtures.h"
#import "Fixtures.h"

QuickSpecBegin(InjectionErrorsSpecs)


beforeEach(^{
      ApplauseJSObjectionInjector *injector = [ApplauseJSObjection createInjector];
      [ApplauseJSObjection setDefaultInjector:injector];
});

it(@"throws an exception if property type is not an object", ^{
    expectAction([[ApplauseJSObjection defaultInjector] getObject:[UnsupportedPropertyObject class]]).to(raiseException().reason(@"Unable to determine class type for property declaration: 'myInteger'"));
});

it(@"throws an exception if property cannot be found", ^{
    expectAction([[ApplauseJSObjection defaultInjector] getObject:[BadPropertyObject class]]).to(raiseException().reason(@"Unable to find property declaration: 'badProperty' for class 'BadPropertyObject'"));
});

it(@"throws if an object requires a protocol that does not exist in the context", ^{
    expectAction([[ApplauseJSObjection defaultInjector] getObject:[FiveSpeedCar class]]).to(raiseException().reason(@"Cannot find an instance that is bound to the protocol 'GearBox' to assign to the property 'gearBox'"));
});

it(@"throws if instantiation rule is not valid", ^{
    expectAction([ApplauseJSObjection registerClass:[CarFactory class] scope:3]).to(raiseException().reason(@"Invalid Instantiation Rule"));
});

describe(@"named properties",^{
      beforeEach(^{
          ApplauseJSObjectionInjector *injector = [ApplauseJSObjection createInjector];
          [ApplauseJSObjection setDefaultInjector:injector];
      });

      it(@"throws an exception if property type is not an object", ^{
            expectAction([[ApplauseJSObjection defaultInjector] getObject:[NamedUnsupportedPropertyObject class]]).to(raiseException().reason(@"Unable to determine class type for property declaration: 'myInteger'"));
      });

      it(@"throws an exception if property cannot be found", ^{
          expectAction([[ApplauseJSObjection defaultInjector] getObject:[NamedBadPropertyObject class]]).to(raiseException().reason(@"Unable to find property declaration: 'badProperty' for class 'NamedBadPropertyObject'"));
      });
});


QuickSpecEnd