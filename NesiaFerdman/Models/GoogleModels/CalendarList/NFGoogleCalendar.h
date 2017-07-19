#import <UIKit/UIKit.h>
#import "NFDefaultReminder.h"

@interface NFGoogleCalendar : NSObject

@property (nonatomic, strong) NSString * accessRole;
@property (nonatomic, strong) NSString * appId;
@property (nonatomic, strong) NSString * backgroundColor;
@property (nonatomic, strong) NSString * colorId;
@property (nonatomic, strong) NSArray * defaultReminders;
@property (nonatomic, strong) NSString * etag;
@property (nonatomic, strong) NSString * foregroundColor;
@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * kind;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) BOOL selectedInApp;
@property (nonatomic, strong) NSString * summary;
@property (nonatomic, strong) NSString * timeZone;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end