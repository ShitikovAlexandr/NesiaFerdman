//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/12/17.
//  Copyright © 2017 Gemicle. All rights reserved.

#import <UIKit/UIKit.h>
#import "NFNValue.h"
#import "NFNGoogleEvent.h"
#import <GTLRCalendar.h>

typedef NS_ENUM(NSUInteger, EventType)
{
    Event,
    Important,
    Conclusions
};

typedef NS_ENUM(NSUInteger, NSocialType)
{
    NNesiaEvent,
    NGoogleEvent,
    NPhoneEvent
};

@interface NFNEvent : NSObject

@property (nonatomic, strong) NSString * updateDate;
@property (nonatomic, strong) NSString * calendarColor;
@property (nonatomic, strong) NSString * calendarID;
@property (nonatomic, strong) NSString * createDate;
@property (nonatomic, strong) NSString * endDate;
@property (nonatomic, strong) NSString * eventDescription;
@property (nonatomic, strong) NSString * eventId;
@property (nonatomic, strong) NSString * socialId;
@property (nonatomic, assign) NSInteger eventType;
@property (nonatomic, assign) BOOL isDeleted;
@property (nonatomic, assign) BOOL isDone;
@property (nonatomic, assign) BOOL isImportant;
@property (nonatomic, assign) BOOL isRepeat;
@property (nonatomic, assign) NSInteger socialType;
@property (nonatomic, strong) NSString * startDate;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSMutableArray * values;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (instancetype)initWithGoogleEvent:(NFNGoogleEvent *)event;

- (void)updateEvent:(NFNEvent*)oldEvent withNewEvent:(NFNEvent*)newEvent;

- (NSDictionary *)toDictionary;

- (GTLRCalendar_Event*)toGoogleEvent;

@end
