//
//	NFNRsultCategory.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/12/17.
//  Copyright © 2017 Gemicle. All rights reserved.



#import "NFNRsultCategory.h"

NSString *const kNFNRsultCategoryIndex = @"Index";
NSString *const kNFNRsultCategoryIdField = @"id";
NSString *const kNFNRsultCategoryTitle = @"title";

@interface NFNRsultCategory ()
@end
@implementation NFNRsultCategory

/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kNFNRsultCategoryIndex] isKindOfClass:[NSNull class]]){
		self.index = [dictionary[kNFNRsultCategoryIndex] integerValue];
	}

	if(![dictionary[kNFNRsultCategoryIdField] isKindOfClass:[NSNull class]]){
		self.idField = dictionary[kNFNRsultCategoryIdField];
	}	
	if(![dictionary[kNFNRsultCategoryTitle] isKindOfClass:[NSNull class]]){
		self.title = dictionary[kNFNRsultCategoryTitle];
	}	
	return self;
}

/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	dictionary[kNFNRsultCategoryIndex] = @(self.index);
	if(self.idField != nil){
		dictionary[kNFNRsultCategoryIdField] = self.idField;
	}
	if(self.title != nil){
		dictionary[kNFNRsultCategoryTitle] = self.title;
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
	[aCoder encodeObject:@(self.index) forKey:kNFNRsultCategoryIndex];	if(self.idField != nil){
		[aCoder encodeObject:self.idField forKey:kNFNRsultCategoryIdField];
	}
	if(self.title != nil){
		[aCoder encodeObject:self.title forKey:kNFNRsultCategoryTitle];
	}
}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.index = [[aDecoder decodeObjectForKey:kNFNRsultCategoryIndex] integerValue];
	self.idField = [aDecoder decodeObjectForKey:kNFNRsultCategoryIdField];
	self.title = [aDecoder decodeObjectForKey:kNFNRsultCategoryTitle];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	NFNRsultCategory *copy = [NFNRsultCategory new];

	copy.index = self.index;
	copy.idField = [self.idField copy];
	copy.title = [self.title copy];

	return copy;
}
@end
