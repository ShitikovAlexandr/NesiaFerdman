//
//	NFNValue.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/12/17.
//  Copyright © 2017 Gemicle. All rights reserved.

#import "NFNValue.h"

NSString *const kNFNValueIsDeleted = @"isDeleted";
NSString *const kNFNValueValueId = @"valueId";
NSString *const kNFNValueValueImage = @"valueImage";
NSString *const kNFNValueValueIndex = @"valueIndex";
NSString *const kNFNValueValueTitle = @"valueTitle";

@interface NFNValue ()
@end
@implementation NFNValue


- (instancetype)init {
    self = [super init];
    if (self) {
        self.valueId = [[NSUUID UUID] UUIDString];
    }
    return self;
}

/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kNFNValueIsDeleted] isKindOfClass:[NSNull class]]){
		self.isDeleted = [dictionary[kNFNValueIsDeleted] boolValue];
	}

	if(![dictionary[kNFNValueValueId] isKindOfClass:[NSNull class]]){
		self.valueId = dictionary[kNFNValueValueId];
	}	
	if(![dictionary[kNFNValueValueImage] isKindOfClass:[NSNull class]]){
		self.valueImage = dictionary[kNFNValueValueImage];
	}	
	if(![dictionary[kNFNValueValueIndex] isKindOfClass:[NSNull class]]){
		self.valueIndex = [dictionary[kNFNValueValueIndex] integerValue];
	}

	if(![dictionary[kNFNValueValueTitle] isKindOfClass:[NSNull class]]){
		self.valueTitle = dictionary[kNFNValueValueTitle];
	}	
	return self;
}

/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
- (NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	dictionary[kNFNValueIsDeleted] = @(self.isDeleted);
	if(self.valueId != nil){
		dictionary[kNFNValueValueId] = self.valueId;
	}
	if(self.valueImage != nil){
		dictionary[kNFNValueValueImage] = self.valueImage;
	}
	dictionary[kNFNValueValueIndex] = @(self.valueIndex);
	if(self.valueTitle != nil){
		dictionary[kNFNValueValueTitle] = self.valueTitle;
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
	[aCoder encodeObject:@(self.isDeleted) forKey:kNFNValueIsDeleted];	if(self.valueId != nil){
		[aCoder encodeObject:self.valueId forKey:kNFNValueValueId];
	}
	if(self.valueImage != nil){
		[aCoder encodeObject:self.valueImage forKey:kNFNValueValueImage];
	}
	[aCoder encodeObject:@(self.valueIndex) forKey:kNFNValueValueIndex];	if(self.valueTitle != nil){
		[aCoder encodeObject:self.valueTitle forKey:kNFNValueValueTitle];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.isDeleted = [[aDecoder decodeObjectForKey:kNFNValueIsDeleted] boolValue];
	self.valueId = [aDecoder decodeObjectForKey:kNFNValueValueId];
	self.valueImage = [aDecoder decodeObjectForKey:kNFNValueValueImage];
	self.valueIndex = [[aDecoder decodeObjectForKey:kNFNValueValueIndex] integerValue];
	self.valueTitle = [aDecoder decodeObjectForKey:kNFNValueValueTitle];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	NFNValue *copy = [NFNValue new];

	copy.isDeleted = self.isDeleted;
	copy.valueId = [self.valueId copy];
	copy.valueImage = [self.valueImage copy];
	copy.valueIndex = self.valueIndex;
	copy.valueTitle = [self.valueTitle copy];

	return copy;
}
@end
