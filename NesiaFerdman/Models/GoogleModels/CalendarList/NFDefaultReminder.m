//
//	NFDefaultReminder.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "NFDefaultReminder.h"

NSString *const kNFDefaultReminderMethod = @"method";
NSString *const kNFDefaultReminderMinutes = @"minutes";

@interface NFDefaultReminder ()
@end
@implementation NFDefaultReminder




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kNFDefaultReminderMethod] isKindOfClass:[NSNull class]]){
		self.method = dictionary[kNFDefaultReminderMethod];
	}	
	if(![dictionary[kNFDefaultReminderMinutes] isKindOfClass:[NSNull class]]){
		self.minutes = [dictionary[kNFDefaultReminderMinutes] integerValue];
	}

	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.method != nil){
		dictionary[kNFDefaultReminderMethod] = self.method;
	}
	dictionary[kNFDefaultReminderMinutes] = @(self.minutes);
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
	if(self.method != nil){
		[aCoder encodeObject:self.method forKey:kNFDefaultReminderMethod];
	}
	[aCoder encodeObject:@(self.minutes) forKey:kNFDefaultReminderMinutes];
}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.method = [aDecoder decodeObjectForKey:kNFDefaultReminderMethod];
	self.minutes = [[aDecoder decodeObjectForKey:kNFDefaultReminderMinutes] integerValue];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	NFDefaultReminder *copy = [NFDefaultReminder new];

	copy.method = [self.method copy];
	copy.minutes = self.minutes;

	return copy;
}
@end