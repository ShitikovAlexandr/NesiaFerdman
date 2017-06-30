//
//  NFGoogleManager.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 4/12/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTMOAuth2ViewControllerTouch.h"
#import "GTLCalendar.h"
#import "NFEvent.h"

@interface NFGoogleManager : NSObject

@property (strong, nonatomic) NSMutableArray *eventsArray;
@property (strong, nonatomic) GTLServiceCalendar *service;
@property (strong, nonatomic) NSString *userID;


+ (NFGoogleManager *)sharedManager;

- (BOOL)isLoginWithTarget:(id)target;
- (void)loginWithGoogleWithTarget:(UIViewController *)target;
- (void)logOutWithTarget:(id)target;

- (NSString *)getUserId;
- (NSString *)getGoogleToken;

- (void)fetchEventsWithCount:(NSInteger)count minDate:(NSDate *)minDate maxDate:(NSDate *)maxDate;
- (NFEvent *)NFEventFromGoogle:(GTLCalendarEvent *)googleEvent;

- (void)addEventToGoogleCalendar:(NFEvent*)event;
- (void)updateGoogleEventWith:(NFEvent*)event;
- (void)deleteGoogleEventWithEvent:(NFEvent*)event;

- (NFEvent *)NFEventFromGoogle:(GTLCalendarEvent *)googleEvent;


@end
