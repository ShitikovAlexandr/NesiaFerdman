//	NFNManifestation.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 7/12/17.
//  Copyright © 2017 Gemicle. All rights reserved.

#import "NFNManifestation.h"

NSString *const kNFNManifestationIndex = @"Index";
NSString *const kNFNManifestationCreateDate = @"createDate";
NSString *const kNFNManifestationIdField = @"id";
NSString *const kNFNManifestationParentId = @"parentId";
NSString *const kNFNManifestationTitle = @"title";

@interface NFNManifestation ()
@end
@implementation NFNManifestation

/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kNFNManifestationIndex] isKindOfClass:[NSNull class]]){
		self.index = [dictionary[kNFNManifestationIndex] integerValue];
	}

	if(![dictionary[kNFNManifestationCreateDate] isKindOfClass:[NSNull class]]){
		self.createDate = dictionary[kNFNManifestationCreateDate];
	}	
	if(![dictionary[kNFNManifestationIdField] isKindOfClass:[NSNull class]]){
		self.idField = dictionary[kNFNManifestationIdField];
	}	
	if(![dictionary[kNFNManifestationParentId] isKindOfClass:[NSNull class]]){
		self.parentId = dictionary[kNFNManifestationParentId];
	}	
	if(![dictionary[kNFNManifestationTitle] isKindOfClass:[NSNull class]]){
		self.title = dictionary[kNFNManifestationTitle];
	}	
	return self;
}

/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	dictionary[kNFNManifestationIndex] = @(self.index);
	if(self.createDate != nil){
		dictionary[kNFNManifestationCreateDate] = self.createDate;
	}
	if(self.idField != nil){
		dictionary[kNFNManifestationIdField] = self.idField;
	}
	if(self.parentId != nil){
		dictionary[kNFNManifestationParentId] = self.parentId;
	}
	if(self.title != nil){
		dictionary[kNFNManifestationTitle] = self.title;
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
	[aCoder encodeObject:@(self.index) forKey:kNFNManifestationIndex];	if(self.createDate != nil){
		[aCoder encodeObject:self.createDate forKey:kNFNManifestationCreateDate];
	}
	if(self.idField != nil){
		[aCoder encodeObject:self.idField forKey:kNFNManifestationIdField];
	}
	if(self.parentId != nil){
		[aCoder encodeObject:self.parentId forKey:kNFNManifestationParentId];
	}
	if(self.title != nil){
		[aCoder encodeObject:self.title forKey:kNFNManifestationTitle];
	}
}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.index = [[aDecoder decodeObjectForKey:kNFNManifestationIndex] integerValue];
	self.createDate = [aDecoder decodeObjectForKey:kNFNManifestationCreateDate];
	self.idField = [aDecoder decodeObjectForKey:kNFNManifestationIdField];
	self.parentId = [aDecoder decodeObjectForKey:kNFNManifestationParentId];
	self.title = [aDecoder decodeObjectForKey:kNFNManifestationTitle];
	return self;
}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	NFNManifestation *copy = [NFNManifestation new];

	copy.index = self.index;
	copy.createDate = [self.createDate copy];
	copy.idField = [self.idField copy];
	copy.parentId = [self.parentId copy];
	copy.title = [self.title copy];

	return copy;
}
@end
