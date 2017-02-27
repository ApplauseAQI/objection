#import <Foundation/Foundation.h>

@protocol ApplauseObjectionCreatable <NSObject>

@optional

+ (NSDictionary *)objectionInitializer;
+ (NSSet *)objectionRequires;
+ (NSDictionary *)objectionRequiresNames;

@end


@interface NSObject(ApplauseObjection) <ApplauseObjectionCreatable>

- (void)awakeFromObjection;

@end
