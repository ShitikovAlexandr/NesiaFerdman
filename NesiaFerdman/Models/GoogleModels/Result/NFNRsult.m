//
//	NFNRsult.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 7/12/17.
//  Copyright © 2017 Gemicle. All rights reserved.

#import "NFNRsult.h"

NSString *const kNFNRsultIndex = @"Index";
NSString *const kNFNRsultCreateDate = @"createDate";
NSString *const kNFNRsultIdField = @"id";
NSString *const kNFNRsultParentId = @"parentId";
NSString *const kNFNRsultTitle = @"title";

@interface NFNRsult ()
@end
@implementation NFNRsult

/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kNFNRsultIndex] isKindOfClass:[NSNull class]]){
		self.index = [dictionary[kNFNRsultIndex] integerValue];
	}

	if(![dictionary[kNFNRsultCreateDate] isKindOfClass:[NSNull class]]){
		self.createDate = dictionary[kNFNRsultCreateDate];
	}	
	if(![dictionary[kNFNRsultIdField] isKindOfClass:[NSNull class]]){
		self.idField = dictionary[kNFNRsultIdField];
	}	
	if(![dictionary[kNFNRsultParentId] isKindOfClass:[NSNull class]]){
		self.parentId = dictionary[kNFNRsultParentId];
	}	
	if(![dictionary[kNFNRsultTitle] isKindOfClass:[NSNull class]]){
		self.title = dictionary[kNFNRsultTitle];
	}	
	return self;
}

/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	dictionary[kNFNRsultIndex] = @(self.index);
	if(self.createDate != nil){
		dictionary[kNFNRsultCreateDate] = self.createDate;
	}
	if(self.idField != nil){
		dictionary[kNFNRsultIdField] = self.idField;
	}
	if(self.parentId != nil){
		dictionary[kNFNRsultParentId] = self.parentId;
	}
	if(self.title != nil){
		dictionary[kNFNRsultTitle] = self.title;
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
	[aCoder encodeObject:@(self.index) forKey:kNFNRsultIndex];	if(self.createDate != nil){
		[aCoder encodeObject:self.createDate forKey:kNFNRsultCreateDate];
	}
	if(self.idField != nil){
		[aCoder encodeObject:self.idField forKey:kNFNRsultIdField];
	}
	if(self.parentId != nil){
		[aCoder encodeObject:self.parentId forKey:kNFNRsultParentId];
	}
	if(self.title != nil){
		[aCoder encodeObject:self.title forKey:kNFNRsultTitle];
	}
}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.index = [[aDecoder decodeObjectForKey:kNFNRsultIndex] integerValue];
	self.createDate = [aDecoder decodeObjectForKey:kNFNRsultCreateDate];
	self.idField = [aDecoder decodeObjectForKey:kNFNRsultIdField];
	self.parentId = [aDecoder decodeObjectForKey:kNFNRsultParentId];
	self.title = [aDecoder decodeObjectForKey:kNFNRsultTitle];
	return self;
}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	NFNRsult *copy = [NFNRsult new];

	copy.index = self.index;
	copy.createDate = [self.createDate copy];
	copy.idField = [self.idField copy];
	copy.parentId = [self.parentId copy];
	copy.title = [self.title copy];
	return copy;
}
@end
