//
//  NFEvent.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/25/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "NFValue.h"

//typedef NS_ENUM(NSUInteger, EventType)
//{
//    Event,
//    Important,
//    Conclusions
//};

typedef NS_ENUM(NSUInteger, SocialType)
{
    NesiaEvent,
    GoogleEvent,
    PhoneEvent
};


@interface NFEvent : NSObject <NSCopying>

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *eventDescription;
@property (strong, nonatomic) NSString *createDate;
@property (strong, nonatomic) NSString *startDate;
@property (strong, nonatomic) NSString *endDate;
@property (assign, nonatomic) BOOL isRepeat;
@property (strong, nonatomic) NSMutableArray *values;
@property (assign, nonatomic) SocialType socialType;
//@property (assign, nonatomic) EventType eventType;
@property (strong, nonatomic) NSString *eventId;
@property (strong, nonatomic) NSString *socialId;
@property (strong, nonatomic) NSString *calendarId;
@property (assign, nonatomic) BOOL isImportant;
@property (assign, nonatomic) BOOL  isDone;

@property (assign, nonatomic) BOOL isDeleted;
@property (strong, nonatomic) NSString *dateChange;

- (NSDictionary *)convertToDictionary;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (instancetype)initWithGoogleEventDictionary:(NSDictionary *)dictionary;

- (NSString *)dateToString:(NSDate *)inputDate;

@end



//pk9ld2om0jmmqu9icikhc4je98
