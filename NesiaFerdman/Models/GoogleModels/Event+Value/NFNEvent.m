//
//	NFNEvent.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 7/12/17.
//  Copyright © 2017 Gemicle. All rights reserved.

#import "NFNEvent.h"
//firebase
NSString *const kNFNEventCalendarColor = @"calendarColor";
NSString *const kNFNEventCalendarID = @"calendarID";
NSString *const kNFNEventCreateDate = @"createDate";
NSString *const kNFNEventEndDate = @"endDate";
NSString *const kNFNEventEventDescription = @"eventDescription";
NSString *const kNFNEventEventId = @"eventId";
NSString *const kNFNEventEventType = @"eventType";
NSString *const kNFNEventIsDeleted = @"isDeleted";
NSString *const kNFNEventIsDone = @"isDone";
NSString *const kNFNEventIsImportant = @"isImportant";
NSString *const kNFNEventIsRepeat = @"isRepeat";
NSString *const kNFNEventSocialType = @"socialType";
NSString *const kNFNEventStartDate = @"startDate";
NSString *const kNFNEventTitle = @"title";
NSString *const kNFNEventValues = @"values";
NSString *const kNFNEventUpdateDate = @"updateDate";
NSString *const kNFNEventSocialId = @"socialId";

@interface NFNEvent ()
@end
@implementation NFNEvent

/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

- (instancetype)init {
    self = [super init];
    if (self) {
        self.eventId = [[NSUUID UUID] UUIDString];
    }
    return self;
}

- (GTLRCalendar_Event*)toGoogleEvent {
    GTLRCalendar_Event *calendarEvent = [[GTLRCalendar_Event alloc] init];
    [calendarEvent setSummary:self.title];
    [calendarEvent setDescriptionProperty:self.eventDescription];
    NSDate *startDate = [self dateFromString:self.startDate];
    NSDate *endDate = [self dateFromString:self.endDate];
    GTLRDateTime *startTime = [GTLRDateTime dateTimeWithDate:startDate];
    GTLRDateTime *endTime = [GTLRDateTime dateTimeWithDate:endDate];
    [calendarEvent setStart:[GTLRCalendar_EventDateTime object]];
    [calendarEvent setEnd:[GTLRCalendar_EventDateTime object]];
    [calendarEvent.start setDateTime:startTime];
    [calendarEvent.end  setDateTime:endTime];
    return calendarEvent;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
    if(![dictionary[kNFNEventSocialId] isKindOfClass:[NSNull class]]){
        self.socialId = dictionary[kNFNEventSocialId];
    }
    if(![dictionary[kNFNEventUpdateDate] isKindOfClass:[NSNull class]]){
        self.updateDate = dictionary[kNFNEventUpdateDate];
    }
	if(![dictionary[kNFNEventCalendarColor] isKindOfClass:[NSNull class]]){
		self.calendarColor = dictionary[kNFNEventCalendarColor];
	}	
	if(![dictionary[kNFNEventCalendarID] isKindOfClass:[NSNull class]]){
		self.calendarID = dictionary[kNFNEventCalendarID];
	}	
	if(![dictionary[kNFNEventCreateDate] isKindOfClass:[NSNull class]]){
		self.createDate = dictionary[kNFNEventCreateDate];
	}	
	if(![dictionary[kNFNEventEndDate] isKindOfClass:[NSNull class]]){
		self.endDate = dictionary[kNFNEventEndDate];
	}	
	if(![dictionary[kNFNEventEventDescription] isKindOfClass:[NSNull class]]){
		self.eventDescription = dictionary[kNFNEventEventDescription];
	}	
	if(![dictionary[kNFNEventEventId] isKindOfClass:[NSNull class]]){
        if (dictionary[kNFNEventEventId] != nil) {
            self.eventId = dictionary[kNFNEventEventId];
        }
	}
	if(![dictionary[kNFNEventEventType] isKindOfClass:[NSNull class]]){
		self.eventType = [dictionary[kNFNEventEventType] integerValue];
	}

	if(![dictionary[kNFNEventIsDeleted] isKindOfClass:[NSNull class]]){
		self.isDeleted = [dictionary[kNFNEventIsDeleted] boolValue];
	}

	if(![dictionary[kNFNEventIsDone] isKindOfClass:[NSNull class]]){
		self.isDone = [dictionary[kNFNEventIsDone] boolValue];
	}

	if(![dictionary[kNFNEventIsImportant] isKindOfClass:[NSNull class]]){
		self.isImportant = [dictionary[kNFNEventIsImportant] boolValue];
	}

	if(![dictionary[kNFNEventIsRepeat] isKindOfClass:[NSNull class]]){
		self.isRepeat = [dictionary[kNFNEventIsRepeat] boolValue];
	}

	if(![dictionary[kNFNEventSocialType] isKindOfClass:[NSNull class]]){
		self.socialType = [dictionary[kNFNEventSocialType] integerValue];
	}

	if(![dictionary[kNFNEventStartDate] isKindOfClass:[NSNull class]]){
		self.startDate = dictionary[kNFNEventStartDate];
	}	
	if(![dictionary[kNFNEventTitle] isKindOfClass:[NSNull class]]){
		self.title = dictionary[kNFNEventTitle];
	}	
	if(dictionary[kNFNEventValues] != nil && [dictionary[kNFNEventValues] isKindOfClass:[NSArray class]]){
		NSArray * valuesDictionaries = dictionary[kNFNEventValues];
		NSMutableArray * valuesItems = [NSMutableArray array];
		for(NSDictionary * valuesDictionary in valuesDictionaries){
			NFNValue * valuesItem = [[NFNValue alloc] initWithDictionary:valuesDictionary];
			[valuesItems addObject:valuesItem];
		}
		self.values = valuesItems;
	}
	return self;
}

- (instancetype)initWithGoogleEvent:(NFNGoogleEvent *)event {
    self = [super init];
    if (self) {
        self.eventId = [[NSUUID UUID] UUIDString];
        self.title = event.summary;
        self.eventDescription = event.descriptionField;
        self.createDate = event.created;
        self.updateDate = event.updated;
        self.startDate = event.start;
        self.endDate = event.end;
        self.eventType = Event;
        self.socialId = event.idField;
        self.calendarID = event.calendarId;
        self.socialType = NGoogleEvent;
    }
    return self;
}

- (void)updateEvent:(NFNEvent*)oldEvent withNewEvent:(NFNEvent*)newEvent {
    oldEvent.title = newEvent.title;
    oldEvent.eventDescription = newEvent.eventDescription;
    oldEvent.startDate = newEvent.startDate;
    oldEvent.endDate = newEvent.endDate;
    oldEvent.updateDate = newEvent.updateDate;
}

/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    if(self.socialId != nil){
        dictionary[kNFNEventSocialId] = self.socialId;
    }
    if(self.updateDate != nil){
        dictionary[kNFNEventUpdateDate] = self.updateDate;
    }
	if(self.calendarColor != nil){
		dictionary[kNFNEventCalendarColor] = self.calendarColor;
	}
	if(self.calendarID != nil){
		dictionary[kNFNEventCalendarID] = self.calendarID;
	}
	if(self.createDate != nil){
		dictionary[kNFNEventCreateDate] = self.createDate;
	}
	if(self.endDate != nil){
		dictionary[kNFNEventEndDate] = self.endDate;
	}
	if(self.eventDescription != nil){
		dictionary[kNFNEventEventDescription] = self.eventDescription;
	}
	if(self.eventId != nil){
		dictionary[kNFNEventEventId] = self.eventId;
	}
	dictionary[kNFNEventEventType] = @(self.eventType);
	dictionary[kNFNEventIsDeleted] = @(self.isDeleted);
	dictionary[kNFNEventIsDone] = @(self.isDone);
	dictionary[kNFNEventIsImportant] = @(self.isImportant);
	dictionary[kNFNEventIsRepeat] = @(self.isRepeat);
	dictionary[kNFNEventSocialType] = @(self.socialType);
	if(self.startDate != nil){
		dictionary[kNFNEventStartDate] = self.startDate;
	}
	if(self.title != nil){
		dictionary[kNFNEventTitle] = self.title;
	}
	if(self.values != nil){
		NSMutableArray * dictionaryElements = [NSMutableArray array];
		for(NFNValue * valuesElement in self.values){
			[dictionaryElements addObject:[valuesElement toDictionary]];
		}
		dictionary[kNFNEventValues] = dictionaryElements;
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
	if(self.calendarColor != nil){
		[aCoder encodeObject:self.calendarColor forKey:kNFNEventCalendarColor];
	}
	if(self.calendarID != nil){
		[aCoder encodeObject:self.calendarID forKey:kNFNEventCalendarID];
	}
	if(self.createDate != nil){
		[aCoder encodeObject:self.createDate forKey:kNFNEventCreateDate];
	}
	if(self.endDate != nil){
		[aCoder encodeObject:self.endDate forKey:kNFNEventEndDate];
	}
	if(self.eventDescription != nil){
		[aCoder encodeObject:self.eventDescription forKey:kNFNEventEventDescription];
	}
	if(self.eventId != nil){
		[aCoder encodeObject:self.eventId forKey:kNFNEventEventId];
	}
	[aCoder encodeObject:@(self.eventType) forKey:kNFNEventEventType];	[aCoder encodeObject:@(self.isDeleted) forKey:kNFNEventIsDeleted];	[aCoder encodeObject:@(self.isDone) forKey:kNFNEventIsDone];	[aCoder encodeObject:@(self.isImportant) forKey:kNFNEventIsImportant];	[aCoder encodeObject:@(self.isRepeat) forKey:kNFNEventIsRepeat];	[aCoder encodeObject:@(self.socialType) forKey:kNFNEventSocialType];	if(self.startDate != nil){
		[aCoder encodeObject:self.startDate forKey:kNFNEventStartDate];
	}
	if(self.title != nil){
		[aCoder encodeObject:self.title forKey:kNFNEventTitle];
	}
	if(self.values != nil){
		[aCoder encodeObject:self.values forKey:kNFNEventValues];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.calendarColor = [aDecoder decodeObjectForKey:kNFNEventCalendarColor];
	self.calendarID = [aDecoder decodeObjectForKey:kNFNEventCalendarID];
	self.createDate = [aDecoder decodeObjectForKey:kNFNEventCreateDate];
	self.endDate = [aDecoder decodeObjectForKey:kNFNEventEndDate];
	self.eventDescription = [aDecoder decodeObjectForKey:kNFNEventEventDescription];
	self.eventId = [aDecoder decodeObjectForKey:kNFNEventEventId];
	self.eventType = [[aDecoder decodeObjectForKey:kNFNEventEventType] integerValue];
	self.isDeleted = [[aDecoder decodeObjectForKey:kNFNEventIsDeleted] boolValue];
	self.isDone = [[aDecoder decodeObjectForKey:kNFNEventIsDone] boolValue];
	self.isImportant = [[aDecoder decodeObjectForKey:kNFNEventIsImportant] boolValue];
	self.isRepeat = [[aDecoder decodeObjectForKey:kNFNEventIsRepeat] boolValue];
	self.socialType = [[aDecoder decodeObjectForKey:kNFNEventSocialType] integerValue];
	self.startDate = [aDecoder decodeObjectForKey:kNFNEventStartDate];
	self.title = [aDecoder decodeObjectForKey:kNFNEventTitle];
	self.values = [aDecoder decodeObjectForKey:kNFNEventValues];
	return self;
}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	NFNEvent *copy = [NFNEvent new];
    
	copy.calendarColor = [self.calendarColor copy];
	copy.calendarID = [self.calendarID copy];
	copy.createDate = [self.createDate copy];
	copy.endDate = [self.endDate copy];
	copy.eventDescription = [self.eventDescription copy];
	copy.eventId = [self.eventId copy];
	copy.eventType = self.eventType;
	copy.isDeleted = self.isDeleted;
	copy.isDone = self.isDone;
	copy.isImportant = self.isImportant;
	copy.isRepeat = self.isRepeat;
	copy.socialType = self.socialType;
	copy.startDate = [self.startDate copy];
	copy.title = [self.title copy];
	copy.values = [self.values copy];
    copy.updateDate = [self.updateDate copy];
    copy.socialId = [self.socialId copy];
	return copy;
}

- (NSDate *)dateFromString:(NSString*)dateString {
    NFDateFormatter *dateFormatter = [[NFDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *dateFromString = [dateFormatter dateFromString:dateString];
    return dateFromString;
}

@end
