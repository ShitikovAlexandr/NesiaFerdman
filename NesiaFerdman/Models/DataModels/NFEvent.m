//
//  NFEvent.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 4/25/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFEvent.h"
#import <objc/runtime.h>

@implementation NFEvent

- (id)copyWithZone:(nullable NSZone *)zone {
    
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.title = [dictionary objectForKey:@"title"];
        self.eventDescription = [dictionary objectForKey:@"eventDescription"];
        self.createDate = [dictionary objectForKey:@"createDate"];
        self.startDate = [dictionary objectForKey:@"startDate"];
        self.endDate = [dictionary objectForKey:@"endDate"];
        self.isRepeat = [[dictionary objectForKey:@"isRepeat"] boolValue];
        if ([dictionary objectForKey:@"values"]) {
            self.values = [NSMutableArray array];
            NSMutableArray *valDic = [NSMutableArray array];
            valDic = [dictionary objectForKey:@"values"];
            for (NSDictionary *val in valDic) {
                NFValue *value = [[NFValue alloc] initWithDictionary:val];
                [self.values addObject:value];
            }
        }
        self.socialType = [[dictionary objectForKey:@"socialType"] integerValue];
        //self.eventType = [[dictionary objectForKey:@"eventType"] integerValue];
        self.eventId = [dictionary objectForKey:@"eventId"];
        self.socialId = [dictionary objectForKey:@"socialId"];
        self.isImportant = [[dictionary objectForKey:@"isImportant"] boolValue];
        self.isDone = [[dictionary objectForKey:@"isDone"] boolValue];
        self.isDeleted = [[dictionary objectForKey:@"isDeleted"] boolValue];
        self.dateChange = [dictionary objectForKey:@"dateChange"];
        if ([dictionary objectForKey:@"calendarId"]) {
            self.calendarId = [dictionary objectForKey:@"calendarId"];
        } else {
            self.calendarId = @"primary";
        }
    }
    return self;
}

- (instancetype)initWithGoogleEventDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.title = [dictionary objectForKey:@"summary"];
        self.eventDescription = [dictionary objectForKey:@"description"];
        self.createDate = [[dictionary objectForKey:@"created"] substringToIndex:19];
        if ([[dictionary objectForKey:@"start"] objectForKey:@"dateTime"]) {
            self.startDate = [[[dictionary objectForKey:@"start"] objectForKey:@"dateTime"] substringToIndex:19];
        } else if ([[dictionary objectForKey:@"start"] objectForKey:@"date"]) {
            self.startDate = [NSString stringWithFormat:@"%@T00:01:00",[[dictionary objectForKey:@"start"] objectForKey:@"date"] ];
        } else {
            self.startDate = [[dictionary objectForKey:@"created"] substringToIndex:19];
        }
        if ([[dictionary objectForKey:@"end"] objectForKey:@"dateTime"]) {
            self.endDate = [[[dictionary objectForKey:@"end"] objectForKey:@"dateTime"] substringToIndex:19];
        } else if ([[dictionary objectForKey:@"end"] objectForKey:@"date"]) {
            self.endDate =  [NSString stringWithFormat:@"%@T00:01:00",[[dictionary objectForKey:@"end"] objectForKey:@"date"]];
        } else  {
            self.endDate = [[dictionary objectForKey:@"created"] substringToIndex:19];
        }
        
        //self.eventType = Event;
        self.socialType = GoogleEvent;
        self.dateChange = [dictionary objectForKey:@"updated"];
        self.calendarId = [[dictionary objectForKey:@"organizer"] objectForKey:@"email"];
        self.socialId = [dictionary objectForKey:@"id"];
        
    }
    return self;
}




- (NSDictionary *)convertToDictionary {
    
    
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithCapacity:count];
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        NSString *value = [self valueForKey:key];
        if (value)
            [dictionary setObject:value forKey:key];
    }
    free(properties);
    return dictionary;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSString *newID = [[NSUUID UUID] UUIDString];
        self.eventId = newID;
        self.createDate = [NSString stringWithFormat:@"%@", [NSDate date]];
        self.startDate = [NSString stringWithFormat:@"%@", [NSDate date]];
        //self.eventType = Event;
    }
    return self;
}

- (NSString *)dateToString:(NSDate *)inputDate {
    NFDateFormatter *dateFormatter = [[NFDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss Z"];
    NSString* newDate = [dateFormatter stringFromDate:inputDate];
    return newDate;
}

@end
