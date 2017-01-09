#import "CircularDependencyFixtures.h"
#import "SpecHelper.h"
#import "Fixtures.h"

QuickSpecBegin(CircularDependencySpecs)
describe(@"circular dependencies", ^{
    
      beforeEach(^{
            ApplauseJSObjectionInjector *injector = [ApplauseJSObjection createInjector];
            [ApplauseJSObjection setDefaultInjector:injector];
      });

      it(@"are resolved between singletons", ^{
            SingletonFoo *foo = [[ApplauseJSObjection defaultInjector] getObject:[SingletonFoo class]];
            SingletonBar *bar = [[ApplauseJSObjection defaultInjector] getObject:[SingletonBar class]];

            assertThat(foo, is(sameInstance(bar.foo)));
            assertThat(foo.bar, is(sameInstance(bar)));
      });
});
QuickSpecEnd