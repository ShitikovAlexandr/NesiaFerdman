//	NFNGoogleEvent.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/12/17.
//  Copyright © 2017 Gemicle. All rights reserved.

#import "NFNGoogleEvent.h"

NSString *const kNFNGoogleEventCalendarId = @"organizer";
NSString *const kNFNGoogleEventEmail = @"email";
NSString *const kNFNGoogleEventCreated = @"created";
NSString *const kNFNGoogleEventDescriptionField = @"description";
NSString *const kNFNGoogleEventEnd = @"end";
NSString *const kNFNGoogleEventEtag = @"etag";
NSString *const kNFNGoogleEventHtmlLink = @"htmlLink";
NSString *const kNFNGoogleEventIdField = @"id";
NSString *const kNFNGoogleEventKind = @"kind";
NSString *const kNFNGoogleEventSequence = @"sequence";
NSString *const kNFNGoogleEventStart = @"start";
NSString *const kNFNGoogleEventStatus = @"status";
NSString *const kNFNGoogleEventSummary = @"summary";
NSString *const kNFNGoogleEventUpdated = @"updated";
NSString *const kNFNGoogleEventDateTime = @"dateTime";
NSString *const kNFNGoogleEventDate = @"date";

@interface NFNGoogleEvent ()
@end
@implementation NFNGoogleEvent

/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![[dictionary[kNFNGoogleEventCalendarId] objectForKey:kNFNGoogleEventEmail]isKindOfClass:[NSNull class]]){
		self.calendarId = [dictionary[kNFNGoogleEventCalendarId] objectForKey:kNFNGoogleEventEmail];
	}	
	if(![dictionary[kNFNGoogleEventCreated] isKindOfClass:[NSNull class]]){
		self.created = dictionary[kNFNGoogleEventCreated];
	}	
	if(![dictionary[kNFNGoogleEventDescriptionField] isKindOfClass:[NSNull class]]){
		self.descriptionField = dictionary[kNFNGoogleEventDescriptionField];
	}	
	if(![[dictionary[kNFNGoogleEventEnd] objectForKey:kNFNGoogleEventDateTime] isKindOfClass:[NSNull class]]) {
        if ([dictionary[kNFNGoogleEventEnd] objectForKey:kNFNGoogleEventDateTime] != nil) {
            self.end = [[dictionary[kNFNGoogleEventEnd] objectForKey:kNFNGoogleEventDateTime] substringToIndex:19];
        } else {
            if ([dictionary[kNFNGoogleEventEnd] objectForKey:kNFNGoogleEventDate] != nil) {
                self.end = [NSString stringWithFormat:@"%@T00:01:00", [dictionary[kNFNGoogleEventEnd] objectForKey:kNFNGoogleEventDate]];
                ;
            } else {
                self.end = [dictionary[kNFNGoogleEventCreated] substringToIndex:19];
            }
        }
	}
	if(![dictionary[kNFNGoogleEventEtag] isKindOfClass:[NSNull class]]){
		self.etag = dictionary[kNFNGoogleEventEtag];
	}	
	if(![dictionary[kNFNGoogleEventHtmlLink] isKindOfClass:[NSNull class]]){
		self.htmlLink = dictionary[kNFNGoogleEventHtmlLink];
	}	
	if(![dictionary[kNFNGoogleEventIdField] isKindOfClass:[NSNull class]]){
		self.idField = dictionary[kNFNGoogleEventIdField];
	}	
	if(![dictionary[kNFNGoogleEventKind] isKindOfClass:[NSNull class]]){
		self.kind = dictionary[kNFNGoogleEventKind];
	}	
	if(![dictionary[kNFNGoogleEventSequence] isKindOfClass:[NSNull class]]){
		self.sequence = [dictionary[kNFNGoogleEventSequence] integerValue];
	}

	if(![[dictionary[kNFNGoogleEventStart] objectForKey:kNFNGoogleEventDateTime]isKindOfClass:[NSNull class]]){
        if ([dictionary[kNFNGoogleEventStart] objectForKey:kNFNGoogleEventDateTime] != nil) {
            self.start = [[dictionary[kNFNGoogleEventStart] objectForKey:kNFNGoogleEventDateTime] substringToIndex:19];
        } else {
            if ([dictionary[kNFNGoogleEventStart] objectForKey:kNFNGoogleEventDate] != nil) {
                self.start = [NSString stringWithFormat:@"%@T00:01:00", [dictionary[kNFNGoogleEventStart] objectForKey:kNFNGoogleEventDate]];
            } else {
                self.start = dictionary[kNFNGoogleEventCreated];
            }
        }
	}
	if(![dictionary[kNFNGoogleEventStatus] isKindOfClass:[NSNull class]]){
		self.status = dictionary[kNFNGoogleEventStatus];
	}	
	if(![dictionary[kNFNGoogleEventSummary] isKindOfClass:[NSNull class]]){
		self.summary = dictionary[kNFNGoogleEventSummary];
	}	
	if(![dictionary[kNFNGoogleEventUpdated] isKindOfClass:[NSNull class]]){
		self.updated = dictionary[kNFNGoogleEventUpdated];
	}	
	return self;
}

/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
- (NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.calendarId != nil){
		dictionary[kNFNGoogleEventCalendarId] = self.calendarId;
	}
	if(self.created != nil){
		dictionary[kNFNGoogleEventCreated] = self.created;
	}
	if(self.descriptionField != nil){
		dictionary[kNFNGoogleEventDescriptionField] = self.descriptionField;
	}
	if(self.end != nil){
		dictionary[kNFNGoogleEventEnd] = self.end;
	}
	if(self.etag != nil){
		dictionary[kNFNGoogleEventEtag] = self.etag;
	}
	if(self.htmlLink != nil){
		dictionary[kNFNGoogleEventHtmlLink] = self.htmlLink;
	}
	if(self.idField != nil){
		dictionary[kNFNGoogleEventIdField] = self.idField;
	}
	if(self.kind != nil){
		dictionary[kNFNGoogleEventKind] = self.kind;
	}
	dictionary[kNFNGoogleEventSequence] = @(self.sequence);
	if(self.start != nil){
		dictionary[kNFNGoogleEventStart] = self.start;
	}
	if(self.status != nil){
		dictionary[kNFNGoogleEventStatus] = self.status;
	}
	if(self.summary != nil){
		dictionary[kNFNGoogleEventSummary] = self.summary;
	}
	if(self.updated != nil){
		dictionary[kNFNGoogleEventUpdated] = self.updated;
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
	if(self.calendarId != nil){
		[aCoder encodeObject:self.calendarId forKey:kNFNGoogleEventCalendarId];
	}
	if(self.created != nil){
		[aCoder encodeObject:self.created forKey:kNFNGoogleEventCreated];
	}
	if(self.descriptionField != nil){
		[aCoder encodeObject:self.descriptionField forKey:kNFNGoogleEventDescriptionField];
	}
	if(self.end != nil){
		[aCoder encodeObject:self.end forKey:kNFNGoogleEventEnd];
	}
	if(self.etag != nil){
		[aCoder encodeObject:self.etag forKey:kNFNGoogleEventEtag];
	}
	if(self.htmlLink != nil){
		[aCoder encodeObject:self.htmlLink forKey:kNFNGoogleEventHtmlLink];
	}
	if(self.idField != nil){
		[aCoder encodeObject:self.idField forKey:kNFNGoogleEventIdField];
	}
	if(self.kind != nil){
		[aCoder encodeObject:self.kind forKey:kNFNGoogleEventKind];
	}
	[aCoder encodeObject:@(self.sequence) forKey:kNFNGoogleEventSequence];	if(self.start != nil){
		[aCoder encodeObject:self.start forKey:kNFNGoogleEventStart];
	}
	if(self.status != nil){
		[aCoder encodeObject:self.status forKey:kNFNGoogleEventStatus];
	}
	if(self.summary != nil){
		[aCoder encodeObject:self.summary forKey:kNFNGoogleEventSummary];
	}
	if(self.updated != nil){
		[aCoder encodeObject:self.updated forKey:kNFNGoogleEventUpdated];
	}
}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.calendarId = [aDecoder decodeObjectForKey:kNFNGoogleEventCalendarId];
	self.created = [aDecoder decodeObjectForKey:kNFNGoogleEventCreated];
	self.descriptionField = [aDecoder decodeObjectForKey:kNFNGoogleEventDescriptionField];
	self.end = [aDecoder decodeObjectForKey:kNFNGoogleEventEnd];
	self.etag = [aDecoder decodeObjectForKey:kNFNGoogleEventEtag];
	self.htmlLink = [aDecoder decodeObjectForKey:kNFNGoogleEventHtmlLink];
	self.idField = [aDecoder decodeObjectForKey:kNFNGoogleEventIdField];
	self.kind = [aDecoder decodeObjectForKey:kNFNGoogleEventKind];
	self.sequence = [[aDecoder decodeObjectForKey:kNFNGoogleEventSequence] integerValue];
	self.start = [aDecoder decodeObjectForKey:kNFNGoogleEventStart];
	self.status = [aDecoder decodeObjectForKey:kNFNGoogleEventStatus];
	self.summary = [aDecoder decodeObjectForKey:kNFNGoogleEventSummary];
	self.updated = [aDecoder decodeObjectForKey:kNFNGoogleEventUpdated];
	return self;
}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	NFNGoogleEvent *copy = [NFNGoogleEvent new];

	copy.calendarId = [self.calendarId copy];
	copy.created = [self.created copy];
	copy.descriptionField = [self.descriptionField copy];
	copy.end = [self.end copy];
	copy.etag = [self.etag copy];
	copy.htmlLink = [self.htmlLink copy];
	copy.idField = [self.idField copy];
	copy.kind = [self.kind copy];
	copy.sequence = self.sequence;
	copy.start = [self.start copy];
	copy.status = [self.status copy];
	copy.summary = [self.summary copy];
	copy.updated = [self.updated copy];

	return copy;
}
@end
