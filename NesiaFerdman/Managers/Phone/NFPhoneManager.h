//
//  NFPhoneManager.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 5/16/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NFEvent.h"
@import EventKit;

@interface NFPhoneManager : NSObject

@property (nonatomic, strong) EKEventStore *eventStore;
@property (nonatomic) BOOL eventsAccessGranted;
@property (strong, nonatomic) NSMutableArray *eventsArray;



+ (NFPhoneManager *)sharedManager;

- (void)getAccess;

- (void)setEventsAccessGranted:(BOOL)eventsAccessGranted;

- (NSArray *)getLocalEventCalendars;

-(void)requestAccessToEvents;

- (void)printEvents;

- (void)getAllEvents;

//- (void)saveEditigEvent:(EKEvent*)event;

- (void)addNewEvent:(EKEvent *)event;

- (void)deleteEvent:(EKEvent *)event;

- (void)deleteEventWithId:(NSString *)idetifire;

- (NFEvent *)NFEventFromPhoneEvent:(EKEvent *)phoneEvent;

//----

- (void)addNewTestEvent;


@end
