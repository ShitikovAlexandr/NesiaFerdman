//
//	NFGoogleUserInfo.m



#import "NFGoogleUserInfo.h"

NSString *const kNFGoogleUserInfoAccessToken = @"access_token";
NSString *const kNFGoogleUserInfoCode = @"code";
NSString *const kNFGoogleUserInfoEmail = @"email";
NSString *const kNFGoogleUserInfoExpiresIn = @"expires_in";
NSString *const kNFGoogleUserInfoIdToken = @"id_token";
NSString *const kNFGoogleUserInfoIsVerified = @"isVerified";
NSString *const kNFGoogleUserInfoRefreshToken = @"refresh_token";
NSString *const kNFGoogleUserInfoScope = @"scope";
NSString *const kNFGoogleUserInfoServiceProvider = @"serviceProvider";
NSString *const kNFGoogleUserInfoTokenType = @"token_type";
NSString *const kNFGoogleUserInfoUserID = @"userID";

@interface NFGoogleUserInfo ()
@end
@implementation NFGoogleUserInfo




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kNFGoogleUserInfoAccessToken] isKindOfClass:[NSNull class]]){
		self.accessToken = dictionary[kNFGoogleUserInfoAccessToken];
	}	
	if(![dictionary[kNFGoogleUserInfoCode] isKindOfClass:[NSNull class]]){
		self.code = dictionary[kNFGoogleUserInfoCode];
	}	
	if(![dictionary[kNFGoogleUserInfoEmail] isKindOfClass:[NSNull class]]){
		self.email = dictionary[kNFGoogleUserInfoEmail];
	}	
	if(![dictionary[kNFGoogleUserInfoExpiresIn] isKindOfClass:[NSNull class]]){
		self.expiresIn = [dictionary[kNFGoogleUserInfoExpiresIn] integerValue];
	}

	if(![dictionary[kNFGoogleUserInfoIdToken] isKindOfClass:[NSNull class]]){
		self.idToken = dictionary[kNFGoogleUserInfoIdToken];
	}	
	if(![dictionary[kNFGoogleUserInfoIsVerified] isKindOfClass:[NSNull class]]){
		self.isVerified = dictionary[kNFGoogleUserInfoIsVerified];
	}	
	if(![dictionary[kNFGoogleUserInfoRefreshToken] isKindOfClass:[NSNull class]]){
		self.refreshToken = dictionary[kNFGoogleUserInfoRefreshToken];
	}	
	if(![dictionary[kNFGoogleUserInfoScope] isKindOfClass:[NSNull class]]){
		self.scope = dictionary[kNFGoogleUserInfoScope];
	}	
	if(![dictionary[kNFGoogleUserInfoServiceProvider] isKindOfClass:[NSNull class]]){
		self.serviceProvider = dictionary[kNFGoogleUserInfoServiceProvider];
	}	
	if(![dictionary[kNFGoogleUserInfoTokenType] isKindOfClass:[NSNull class]]){
		self.tokenType = dictionary[kNFGoogleUserInfoTokenType];
	}	
	if(![dictionary[kNFGoogleUserInfoUserID] isKindOfClass:[NSNull class]]){
		self.userID = dictionary[kNFGoogleUserInfoUserID];
	}	
	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.accessToken != nil){
		dictionary[kNFGoogleUserInfoAccessToken] = self.accessToken;
	}
	if(self.code != nil){
		dictionary[kNFGoogleUserInfoCode] = self.code;
	}
	if(self.email != nil){
		dictionary[kNFGoogleUserInfoEmail] = self.email;
	}
	dictionary[kNFGoogleUserInfoExpiresIn] = @(self.expiresIn);
	if(self.idToken != nil){
		dictionary[kNFGoogleUserInfoIdToken] = self.idToken;
	}
	if(self.isVerified != nil){
		dictionary[kNFGoogleUserInfoIsVerified] = self.isVerified;
	}
	if(self.refreshToken != nil){
		dictionary[kNFGoogleUserInfoRefreshToken] = self.refreshToken;
	}
	if(self.scope != nil){
		dictionary[kNFGoogleUserInfoScope] = self.scope;
	}
	if(self.serviceProvider != nil){
		dictionary[kNFGoogleUserInfoServiceProvider] = self.serviceProvider;
	}
	if(self.tokenType != nil){
		dictionary[kNFGoogleUserInfoTokenType] = self.tokenType;
	}
	if(self.userID != nil){
		dictionary[kNFGoogleUserInfoUserID] = self.userID;
	}
	return dictionary;

}

/**
 * Implementation of NSCoding encoding method
 */
/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
- (void)encodeWithCoder:(NSCoder *)aCoder
{
	if(self.accessToken != nil){
		[aCoder encodeObject:self.accessToken forKey:kNFGoogleUserInfoAccessToken];
	}
	if(self.code != nil){
		[aCoder encodeObject:self.code forKey:kNFGoogleUserInfoCode];
	}
	if(self.email != nil){
		[aCoder encodeObject:self.email forKey:kNFGoogleUserInfoEmail];
	}
	[aCoder encodeObject:@(self.expiresIn) forKey:kNFGoogleUserInfoExpiresIn];	if(self.idToken != nil){
		[aCoder encodeObject:self.idToken forKey:kNFGoogleUserInfoIdToken];
	}
	if(self.isVerified != nil){
		[aCoder encodeObject:self.isVerified forKey:kNFGoogleUserInfoIsVerified];
	}
	if(self.refreshToken != nil){
		[aCoder encodeObject:self.refreshToken forKey:kNFGoogleUserInfoRefreshToken];
	}
	if(self.scope != nil){
		[aCoder encodeObject:self.scope forKey:kNFGoogleUserInfoScope];
	}
	if(self.serviceProvider != nil){
		[aCoder encodeObject:self.serviceProvider forKey:kNFGoogleUserInfoServiceProvider];
	}
	if(self.tokenType != nil){
		[aCoder encodeObject:self.tokenType forKey:kNFGoogleUserInfoTokenType];
	}
	if(self.userID != nil){
		[aCoder encodeObject:self.userID forKey:kNFGoogleUserInfoUserID];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.accessToken = [aDecoder decodeObjectForKey:kNFGoogleUserInfoAccessToken];
	self.code = [aDecoder decodeObjectForKey:kNFGoogleUserInfoCode];
	self.email = [aDecoder decodeObjectForKey:kNFGoogleUserInfoEmail];
	self.expiresIn = [[aDecoder decodeObjectForKey:kNFGoogleUserInfoExpiresIn] integerValue];
	self.idToken = [aDecoder decodeObjectForKey:kNFGoogleUserInfoIdToken];
	self.isVerified = [aDecoder decodeObjectForKey:kNFGoogleUserInfoIsVerified];
	self.refreshToken = [aDecoder decodeObjectForKey:kNFGoogleUserInfoRefreshToken];
	self.scope = [aDecoder decodeObjectForKey:kNFGoogleUserInfoScope];
	self.serviceProvider = [aDecoder decodeObjectForKey:kNFGoogleUserInfoServiceProvider];
	self.tokenType = [aDecoder decodeObjectForKey:kNFGoogleUserInfoTokenType];
	self.userID = [aDecoder decodeObjectForKey:kNFGoogleUserInfoUserID];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	NFGoogleUserInfo *copy = [NFGoogleUserInfo new];

	copy.accessToken = [self.accessToken copy];
	copy.code = [self.code copy];
	copy.email = [self.email copy];
	copy.expiresIn = self.expiresIn;
	copy.idToken = [self.idToken copy];
	copy.isVerified = [self.isVerified copy];
	copy.refreshToken = [self.refreshToken copy];
	copy.scope = [self.scope copy];
	copy.serviceProvider = [self.serviceProvider copy];
	copy.tokenType = [self.tokenType copy];
	copy.userID = [self.userID copy];

	return copy;
}
@end