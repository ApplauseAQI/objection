#import <Foundation/Foundation.h>
#import <objc/objc.h>
#import <objc/runtime.h>

#import "ApplauseJSObjectionModule.h"
#import "ApplauseJSObjectionInjector.h"
#import "ApplauseJSObjectionEntry.h"
#import "ApplauseJSObjectionBindingEntry.h"
#import "NSObject+ApplauseObjection.h"
#import "ApplauseJSObjectionInjectorEntry.h"
#import "ApplauseJSObjectionUtils.h"
#import "ApplauseJSObjectFactory.h"
#import "ApplauseJSObjection.h"

#define apl_objection_register(value)			\
    + (void)initialize { \
        if (self == [value class]) { \
            [ApplauseJSObjection registerClass:[value class] scope: ApplauseJSObjectionScopeNormal]; \
        } \
    }

#define apl_objection_register_singleton(value) \
    + (void)initialize { \
        if (self == [value class]) { \
            [ApplauseJSObjection registerClass:[value class] scope: ApplauseJSObjectionScopeSingleton]; \
        } \
    }

#define apl_objection_requires(args...) \
    + (NSSet *)objectionRequires { \
        NSSet *requirements = [NSSet setWithObjects: args, nil]; \
        return JSObjectionUtils.buildDependenciesForClass(self, requirements); \
    }

#define apl_objection_requires_sel(args...) \
    + (NSSet *)objectionRequires { \
        SEL selectors[] = {args}; \
        NSMutableSet *requirements = [NSMutableSet set]; \
        for (NSUInteger j = 0; j < sizeof(selectors)/ sizeof(SEL); j++) { \
            SEL selector = selectors[j]; \
            [requirements addObject:NSStringFromSelector(selector)]; \
        } \
        return ApplauseJSObjectionUtils.buildDependenciesForClass(self, requirements); \
    }

#define apl_objection_requires_names(namedDependencies) \
    + (NSDictionary *)objectionRequiresNames { \
        return ApplauseJSObjectionUtils.buildNamedDependenciesForClass(self, namedDependencies); \
    }

#define apl_objection_initializer_sel(selectorSymbol, args...) \
    + (NSDictionary *)objectionInitializer { \
        id objs[] = {args}; \
        NSArray *defaultArguments = [NSArray arrayWithObjects: objs count:sizeof(objs)/sizeof(id)]; \
        return ApplauseJSObjectionUtils.buildInitializer(selectorSymbol, defaultArguments); \
    }   

#define apl_objection_initializer(selectorSymbol, args...) apl_objection_initializer_sel(@selector(selectorSymbol), args)
