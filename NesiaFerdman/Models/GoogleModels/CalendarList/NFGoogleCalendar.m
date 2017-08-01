//
//	NFGoogleCalendar.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "NFGoogleCalendar.h"

NSString *const kNFGoogleCalendarAccessRole = @"accessRole";
NSString *const kNFGoogleCalendarAppId = @"appId";
NSString *const kNFGoogleCalendarBackgroundColor = @"backgroundColor";
NSString *const kNFGoogleCalendarColorId = @"colorId";
NSString *const kNFGoogleCalendarDefaultReminders = @"defaultReminders";
NSString *const kNFGoogleCalendarEtag = @"etag";
NSString *const kNFGoogleCalendarForegroundColor = @"foregroundColor";
NSString *const kNFGoogleCalendarIdField = @"id";
NSString *const kNFGoogleCalendarKind = @"kind";
NSString *const kNFGoogleCalendarSelected = @"selected";
NSString *const kNFGoogleCalendarSelectedInApp = @"selectedInApp";
NSString *const kNFGoogleCalendarSummary = @"summary";
NSString *const kNFGoogleCalendarTimeZone = @"timeZone";

@interface NFGoogleCalendar ()
@end
@implementation NFGoogleCalendar

- (void)updateInfoFromCalendar:(NFGoogleCalendar*)calendar {
    self.backgroundColor = calendar.backgroundColor;
    self.summary = calendar.summary;
    self.accessRole = calendar.accessRole;
}


/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kNFGoogleCalendarAccessRole] isKindOfClass:[NSNull class]]){
		self.accessRole = dictionary[kNFGoogleCalendarAccessRole];
	}	
	if(![dictionary[kNFGoogleCalendarAppId] isKindOfClass:[NSNull class]]){
		self.appId = dictionary[kNFGoogleCalendarAppId];
        if (self.appId == nil) {
            self.appId = [[NSUUID UUID] UUIDString];
        }
    }
	if(![dictionary[kNFGoogleCalendarBackgroundColor] isKindOfClass:[NSNull class]]){
		self.backgroundColor = dictionary[kNFGoogleCalendarBackgroundColor];
	}	
	if(![dictionary[kNFGoogleCalendarColorId] isKindOfClass:[NSNull class]]){
		self.colorId = dictionary[kNFGoogleCalendarColorId];
	}	
	if(dictionary[kNFGoogleCalendarDefaultReminders] != nil && [dictionary[kNFGoogleCalendarDefaultReminders] isKindOfClass:[NSArray class]]){
		NSArray * defaultRemindersDictionaries = dictionary[kNFGoogleCalendarDefaultReminders];
		NSMutableArray * defaultRemindersItems = [NSMutableArray array];
		for(NSDictionary * defaultRemindersDictionary in defaultRemindersDictionaries){
			NFDefaultReminder * defaultRemindersItem = [[NFDefaultReminder alloc] initWithDictionary:defaultRemindersDictionary];
			[defaultRemindersItems addObject:defaultRemindersItem];
		}
		self.defaultReminders = defaultRemindersItems;
	}
	if(![dictionary[kNFGoogleCalendarEtag] isKindOfClass:[NSNull class]]){
		self.etag = dictionary[kNFGoogleCalendarEtag];
	}	
	if(![dictionary[kNFGoogleCalendarForegroundColor] isKindOfClass:[NSNull class]]){
		self.foregroundColor = dictionary[kNFGoogleCalendarForegroundColor];
	}	
	if(![dictionary[kNFGoogleCalendarIdField] isKindOfClass:[NSNull class]]){
		self.idField = dictionary[kNFGoogleCalendarIdField];
	}	
	if(![dictionary[kNFGoogleCalendarKind] isKindOfClass:[NSNull class]]){
		self.kind = dictionary[kNFGoogleCalendarKind];
	}	
	if(![dictionary[kNFGoogleCalendarSelected] isKindOfClass:[NSNull class]]){
		self.selected = [dictionary[kNFGoogleCalendarSelected] boolValue];
	}

	if(![dictionary[kNFGoogleCalendarSelectedInApp] isKindOfClass:[NSNull class]]){
		self.selectedInApp = [dictionary[kNFGoogleCalendarSelectedInApp] boolValue];
	}

	if(![dictionary[kNFGoogleCalendarSummary] isKindOfClass:[NSNull class]]){
		self.summary = dictionary[kNFGoogleCalendarSummary];
	}	
	if(![dictionary[kNFGoogleCalendarTimeZone] isKindOfClass:[NSNull class]]){
		self.timeZone = dictionary[kNFGoogleCalendarTimeZone];
	}	
	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.accessRole != nil){
		dictionary[kNFGoogleCalendarAccessRole] = self.accessRole;
	}
	if(self.appId != nil){
		dictionary[kNFGoogleCalendarAppId] = self.appId;
	}
	if(self.backgroundColor != nil){
		dictionary[kNFGoogleCalendarBackgroundColor] = self.backgroundColor;
	}
	if(self.colorId != nil){
		dictionary[kNFGoogleCalendarColorId] = self.colorId;
	}
	if(self.defaultReminders != nil){
		NSMutableArray * dictionaryElements = [NSMutableArray array];
		for(NFDefaultReminder * defaultRemindersElement in self.defaultReminders){
			[dictionaryElements addObject:[defaultRemindersElement toDictionary]];
		}
		dictionary[kNFGoogleCalendarDefaultReminders] = dictionaryElements;
	}
	if(self.etag != nil){
		dictionary[kNFGoogleCalendarEtag] = self.etag;
	}
	if(self.foregroundColor != nil){
		dictionary[kNFGoogleCalendarForegroundColor] = self.foregroundColor;
	}
	if(self.idField != nil){
		dictionary[kNFGoogleCalendarIdField] = self.idField;
	}
	if(self.kind != nil){
		dictionary[kNFGoogleCalendarKind] = self.kind;
	}
	dictionary[kNFGoogleCalendarSelected] = @(self.selected);
	dictionary[kNFGoogleCalendarSelectedInApp] = @(self.selectedInApp);
	if(self.summary != nil){
		dictionary[kNFGoogleCalendarSummary] = self.summary;
	}
	if(self.timeZone != nil){
		dictionary[kNFGoogleCalendarTimeZone] = self.timeZone;
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
	if(self.accessRole != nil){
		[aCoder encodeObject:self.accessRole forKey:kNFGoogleCalendarAccessRole];
	}
	if(self.appId != nil){
		[aCoder encodeObject:self.appId forKey:kNFGoogleCalendarAppId];
	}
	if(self.backgroundColor != nil){
		[aCoder encodeObject:self.backgroundColor forKey:kNFGoogleCalendarBackgroundColor];
	}
	if(self.colorId != nil){
		[aCoder encodeObject:self.colorId forKey:kNFGoogleCalendarColorId];
	}
	if(self.defaultReminders != nil){
		[aCoder encodeObject:self.defaultReminders forKey:kNFGoogleCalendarDefaultReminders];
	}
	if(self.etag != nil){
		[aCoder encodeObject:self.etag forKey:kNFGoogleCalendarEtag];
	}
	if(self.foregroundColor != nil){
		[aCoder encodeObject:self.foregroundColor forKey:kNFGoogleCalendarForegroundColor];
	}
	if(self.idField != nil){
		[aCoder encodeObject:self.idField forKey:kNFGoogleCalendarIdField];
	}
	if(self.kind != nil){
		[aCoder encodeObject:self.kind forKey:kNFGoogleCalendarKind];
	}
	[aCoder encodeObject:@(self.selected) forKey:kNFGoogleCalendarSelected];	[aCoder encodeObject:@(self.selectedInApp) forKey:kNFGoogleCalendarSelectedInApp];	if(self.summary != nil){
		[aCoder encodeObject:self.summary forKey:kNFGoogleCalendarSummary];
	}
	if(self.timeZone != nil){
		[aCoder encodeObject:self.timeZone forKey:kNFGoogleCalendarTimeZone];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.accessRole = [aDecoder decodeObjectForKey:kNFGoogleCalendarAccessRole];
	self.appId = [aDecoder decodeObjectForKey:kNFGoogleCalendarAppId];
	self.backgroundColor = [aDecoder decodeObjectForKey:kNFGoogleCalendarBackgroundColor];
	self.colorId = [aDecoder decodeObjectForKey:kNFGoogleCalendarColorId];
	self.defaultReminders = [aDecoder decodeObjectForKey:kNFGoogleCalendarDefaultReminders];
	self.etag = [aDecoder decodeObjectForKey:kNFGoogleCalendarEtag];
	self.foregroundColor = [aDecoder decodeObjectForKey:kNFGoogleCalendarForegroundColor];
	self.idField = [aDecoder decodeObjectForKey:kNFGoogleCalendarIdField];
	self.kind = [aDecoder decodeObjectForKey:kNFGoogleCalendarKind];
	self.selected = [[aDecoder decodeObjectForKey:kNFGoogleCalendarSelected] boolValue];
	self.selectedInApp = [[aDecoder decodeObjectForKey:kNFGoogleCalendarSelectedInApp] boolValue];
	self.summary = [aDecoder decodeObjectForKey:kNFGoogleCalendarSummary];
	self.timeZone = [aDecoder decodeObjectForKey:kNFGoogleCalendarTimeZone];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	NFGoogleCalendar *copy = [NFGoogleCalendar new];

	copy.accessRole = [self.accessRole copy];
	copy.appId = [self.appId copy];
	copy.backgroundColor = [self.backgroundColor copy];
	copy.colorId = [self.colorId copy];
	copy.defaultReminders = [self.defaultReminders copy];
	copy.etag = [self.etag copy];
	copy.foregroundColor = [self.foregroundColor copy];
	copy.idField = [self.idField copy];
	copy.kind = [self.kind copy];
	copy.selected = self.selected;
	copy.selectedInApp = self.selectedInApp;
	copy.summary = [self.summary copy];
	copy.timeZone = [self.timeZone copy];

	return copy;
}
@end
