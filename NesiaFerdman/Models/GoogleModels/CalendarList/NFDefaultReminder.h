#import <UIKit/UIKit.h>

@interface NFDefaultReminder : NSObject

@property (nonatomic, strong) NSString * method;
@property (nonatomic, assign) NSInteger minutes;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end