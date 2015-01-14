#import "SpecHelper.h"

@interface Person : NSObject
{
  NSDictionary *_attributes;
}

@property (nonatomic, strong) NSDictionary *attributes;
@end

@implementation Person
apl_objection_register(Person)
apl_objection_requires(@"attributes")
@synthesize attributes=_attributes;
@end

@interface Programmer : Person
{
  NSDictionary *_favoriteLanguages;
}
@property (nonatomic, strong) NSDictionary *favoriteLanguages;
@end

@implementation Programmer
apl_objection_register(Programmer)
apl_objection_requires(@"favoriteLanguages")
@synthesize favoriteLanguages=_favoriteLanguages;

@end

@interface NoInheritance : NSObject
{
  NSString *_something;
}

@property (nonatomic, strong) NSString *something;

@end

@implementation NoInheritance
apl_objection_register(NoInheritance)
apl_objection_requires(@"something")

@synthesize something=_something;

@end


SPEC_BEGIN(InheritanceSpecs)
beforeEach(^{
      ApplauseJSObjectionInjector *injector = [ApplauseJSObjection createInjector];
      [ApplauseJSObjection setDefaultInjector:injector];
});

it(@"coalesces dependencies from parent to child", ^{
      Programmer *programmer = [[ApplauseJSObjection defaultInjector] getObject:[Programmer class]];
      assertThat(programmer, is(notNilValue()));
      assertThat(programmer.favoriteLanguages, is(notNilValue()));
      assertThat(programmer.attributes, is(notNilValue()));
});

it(@"does not throw a fit if the base class does not implement .objectionRequires", ^{
      NoInheritance *noParentObjectWithRequires = [[ApplauseJSObjection defaultInjector] getObject:[NoInheritance class]];
      assertThat(noParentObjectWithRequires.something, is(notNilValue()));
});
SPEC_END
