#import <UIKit/UIKit.h>

@interface NFNQuote : NSObject

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSString * author;
@property (nonatomic, strong) NSString * date;
@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * title;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end