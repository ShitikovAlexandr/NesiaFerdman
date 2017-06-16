//
//  NFPhoneManager.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 5/16/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFPhoneManager.h"
#import "NotifyList.h"

@interface NFPhoneManager()
@property (strong, nonatomic) NSMutableArray *dataArray;
@end

@implementation NFPhoneManager

+ (NFPhoneManager *)sharedManager {
    static NFPhoneManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.eventsArray = [NSMutableArray array];
        self.dataArray = [NSMutableArray array];
        self.eventStore = [[EKEventStore alloc] init];
    }
    return self;
}

- (void)getAccess {
    [self requestAccessToEvents];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    // Check if the access granted value for the events exists in the user defaults dictionary.
    if ([userDefaults valueForKey:@"eventkit_events_access_granted"] != nil) {
        // The value exists, so assign it to the property.
        self.eventsAccessGranted = [[userDefaults valueForKey:@"eventkit_events_access_granted"] intValue];
    } else {
        // Set the default value.
        self.eventsAccessGranted = NO;
    }
    
}

- (void)setEventsAccessGranted:(BOOL)eventsAccessGranted {
    _eventsAccessGranted = eventsAccessGranted;
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:eventsAccessGranted] forKey:@"eventkit_events_access_granted"];
}

- (NSArray *)getLocalEventCalendars {
    NSArray *allCalendars = [self.eventStore calendarsForEntityType:EKEntityTypeEvent];
    NSMutableArray *localCalendars = [[NSMutableArray alloc] init];
    for (int i=0; i<allCalendars.count; i++) {
        EKCalendar *currentCalendar = [allCalendars objectAtIndex:i];
        NSLog(@"event %@", currentCalendar.title);
        //if (currentCalendar.type == EKCalendarTypeLocal) {
        [localCalendars addObject:currentCalendar];
        // }
    }
    //[self PrintEventsWithCalendarArray:localCalendars];
    
    return (NSArray *)localCalendars;
}

- (void)printEvents {
    NSDate* endDate =  [NSDate dateWithTimeIntervalSinceNow:[[NSDate distantFuture] timeIntervalSinceReferenceDate]];
    NSLog(@"end date %@", endDate);
    NSPredicate *fetchCalendarEvents = [_eventStore predicateForEventsWithStartDate:[NSDate date] endDate:endDate calendars:_dataArray];
    NSArray *eventList = [_eventStore eventsMatchingPredicate:fetchCalendarEvents];
    
    for(int i=0; i < eventList.count; i++){
        EKEvent *event = [eventList objectAtIndex:i];
        NSLog(@"Event Title:%@", event.title);
        NSLog(@"Event Title:%@", event.eventIdentifier);
    }
}

- (void)getAllEvents {
    [self.dataArray removeAllObjects];
    self.dataArray = (NSMutableArray*)[self getLocalEventCalendars];
    NSMutableArray *evansArray = [NSMutableArray array];
    
    NSDate* endDate =  [NSDate dateWithTimeIntervalSinceNow:[[NSDate distantFuture] timeIntervalSinceReferenceDate]];
    NSLog(@"end date %@", endDate);
    NSPredicate *fetchCalendarEvents = [_eventStore predicateForEventsWithStartDate:[NSDate date] endDate:endDate calendars:_dataArray];
    NSArray *eventList = [_eventStore eventsMatchingPredicate:fetchCalendarEvents];
    
    NSString *tempEventId = @"";
    for(int i=0; i < eventList.count; i++) {
        EKEvent *event = [eventList objectAtIndex:i];
        if (![event.eventIdentifier isEqualToString:tempEventId]) {
            tempEventId = event.eventIdentifier;
            [evansArray addObject:[self NFEventFromPhoneEvent:event]];
            NSLog(@"Event Title:%@", event.title);
             NSLog(@"Event Notes:%@", event.notes);
            NSLog(@"Event Identifier:%@", event.eventIdentifier);
            NSLog(@"Event startDate:%@", event.startDate);
            NSLog(@"Event endDate:%@", event.endDate);
            NSLog(@"Event calendar:%@", event.calendar.title);
            NSLog(@"Event calendarId:%@ __________\n", event.calendar.calendarIdentifier);
        }
    }
    [self.eventsArray addObjectsFromArray:evansArray];
//    NSNotification *notification = [NSNotification notificationWithName:PHONE_NOTIF object:self];
//    [[NSNotificationCenter defaultCenter]postNotification:notification];
}


- (void)requestAccessToEvents {
    [self.eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (error == nil) {
            // Store the returned granted value.
            self.eventsAccessGranted = granted;
        }
        else {
            // In case of error, just log its description to the debugger.
            NSLog(@"%@---->", [error localizedDescription]);
        }
    }];
}

//- (void)saveEditigEvent:(EKEvent*)event {
//    NSError *err = nil;
//    [_eventStore saveEvent:event span:EKSpanFutureEvents commit:YES error:&err];
//    if (err) {
//        NSLog(@"error save changes EKEvent %@", err);
//    }
//}

- (void)deleteEvent:(EKEvent *)event {
    NSError *error = nil;
    [self.eventStore removeEvent:event span: EKSpanFutureEvents error:&error];
}

- (void)deleteEventWithId:(NSString *)idetifire {
    NSError *error = nil;
    EKEvent *eventToRemove = [self.eventStore eventWithIdentifier:idetifire];
    if (eventToRemove != nil) {
        [self.eventStore removeEvent:eventToRemove span: EKSpanFutureEvents error:&error];
    }
}

- (void)addNewEvent:(EKEvent *)inputEvent {
    EKEvent *event = [EKEvent eventWithEventStore:_eventStore];
    event.title = @"Event  created by Nesia";
    event.startDate = [NSDate date]; // today
    event.endDate = [event.startDate dateByAddingTimeInterval:60*60];  // Duration 1 hr
    [event setCalendar:[_eventStore defaultCalendarForNewEvents]];
    NSError *err = nil;
    [_eventStore saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
}

- (void)addNewTestEvent {
    EKEvent *event = [EKEvent eventWithEventStore:_eventStore];
    event.title = [NSString stringWithFormat:@"Event  created by Nesia %d", arc4random_uniform(9999999)];
    event.startDate = [NSDate date]; // today
    event.endDate = [event.startDate dateByAddingTimeInterval:60*60];  // Duration 1 hr
    [event setCalendar:[_eventStore defaultCalendarForNewEvents]];
    NSError *err = nil;
    [_eventStore saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
}

- (NFEvent *)NFEventFromPhoneEvent:(EKEvent *)phoneEvent {
    NFEvent *event = [[NFEvent alloc]  init];
    //NSLog(@"Google event %@", googleEvent.JSON);
    event.title = phoneEvent.title;
    event.eventDescription = phoneEvent.notes?phoneEvent.notes:@"";
    event.createDate = [event dateToString:phoneEvent.creationDate];
    NSLog(@"phoneEvent.creationDate %@", phoneEvent.creationDate);
    event.startDate = [event dateToString:phoneEvent.startDate];
    event.endDate = [event dateToString:phoneEvent.endDate];
    //event.isRepeat = @"";
    //event.value = @"";
    event.eventType = Event;
    event.socialType = PhoneEvent;
    //event.eventId = phoneEvent.eventIdentifier;
    event.socialId = phoneEvent.eventIdentifier;
    return event;

}

@end
