#import <UIKit/UIKit.h>

@interface NFGoogleUserInfo : NSObject

@property (nonatomic, strong) NSString * accessToken;
@property (nonatomic, strong) NSString * code;
@property (nonatomic, strong) NSString * email;
@property (nonatomic, assign) NSInteger expiresIn;
@property (nonatomic, strong) NSString * idToken;
@property (nonatomic, strong) NSString * isVerified;
@property (nonatomic, strong) NSString * refreshToken;
@property (nonatomic, strong) NSString * scope;
@property (nonatomic, strong) NSString * serviceProvider;
@property (nonatomic, strong) NSString * tokenType;
@property (nonatomic, strong) NSString * userID;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end