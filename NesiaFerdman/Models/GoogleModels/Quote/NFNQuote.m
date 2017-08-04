//
//	NFNQuote.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "NFNQuote.h"

NSString *const kNFNQuoteIndex = @"Index";
NSString *const kNFNQuoteAuthor = @"author";
NSString *const kNFNQuoteDate = @"date";
NSString *const kNFNQuoteIdField = @"id";
NSString *const kNFNQuoteTitle = @"title";

@interface NFNQuote ()
@end
@implementation NFNQuote

- (instancetype)init  {
    self = [super init];
    if (self) {
        self.idField = [[NSUUID UUID] UUIDString];
    }
    return self;
}

/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kNFNQuoteIndex] isKindOfClass:[NSNull class]]){
		self.index = [dictionary[kNFNQuoteIndex] integerValue];
	}

	if(![dictionary[kNFNQuoteAuthor] isKindOfClass:[NSNull class]]){
		self.author = dictionary[kNFNQuoteAuthor];
	}	
	if(![dictionary[kNFNQuoteDate] isKindOfClass:[NSNull class]]){
		self.date = dictionary[kNFNQuoteDate];
	}	
	if(![dictionary[kNFNQuoteIdField] isKindOfClass:[NSNull class]]){
		self.idField = dictionary[kNFNQuoteIdField];
	}	
	if(![dictionary[kNFNQuoteTitle] isKindOfClass:[NSNull class]]){
		self.title = dictionary[kNFNQuoteTitle];
	}	
	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	dictionary[kNFNQuoteIndex] = @(self.index);
	if(self.author != nil){
		dictionary[kNFNQuoteAuthor] = self.author;
	}
	if(self.date != nil){
		dictionary[kNFNQuoteDate] = self.date;
	}
	if(self.idField != nil){
		dictionary[kNFNQuoteIdField] = self.idField;
	}
	if(self.title != nil){
		dictionary[kNFNQuoteTitle] = self.title;
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
	[aCoder encodeObject:@(self.index) forKey:kNFNQuoteIndex];	if(self.author != nil){
		[aCoder encodeObject:self.author forKey:kNFNQuoteAuthor];
	}
	if(self.date != nil){
		[aCoder encodeObject:self.date forKey:kNFNQuoteDate];
	}
	if(self.idField != nil){
		[aCoder encodeObject:self.idField forKey:kNFNQuoteIdField];
	}
	if(self.title != nil){
		[aCoder encodeObject:self.title forKey:kNFNQuoteTitle];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.index = [[aDecoder decodeObjectForKey:kNFNQuoteIndex] integerValue];
	self.author = [aDecoder decodeObjectForKey:kNFNQuoteAuthor];
	self.date = [aDecoder decodeObjectForKey:kNFNQuoteDate];
	self.idField = [aDecoder decodeObjectForKey:kNFNQuoteIdField];
	self.title = [aDecoder decodeObjectForKey:kNFNQuoteTitle];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	NFNQuote *copy = [NFNQuote new];

	copy.index = self.index;
	copy.author = [self.author copy];
	copy.date = [self.date copy];
	copy.idField = [self.idField copy];
	copy.title = [self.title copy];

	return copy;
}
@end
