//
//  NFGoogleManager.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 4/12/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFGoogleManager.h"
#import "NFConstants.h"
#import "NFSplashViewController.h"
#import "NFLoginSimpleController.h"
#import "NFGoogleUserInfo.h"
#import "NotifyList.h"
#import "NFSyncManager.h"

static NSString *const kKeychainItemName = @"Google Calendar API";
static NSString *const kClientID = @"270949290072-8d4197i3nk6hvk1774a1heghuskugo3m.apps.googleusercontent.com";
static NSString *const kAppCalendar = @"Nesia Ferdman";

@interface NFGoogleManager()
@property (strong, nonatomic) UIViewController *target;
@end
@implementation NFGoogleManager
@synthesize service = _service;

+ (NFGoogleManager *)sharedManager {
    static NFGoogleManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (BOOL)isLoginWithTarget:(id)target {
    self.target = target;
    self.service = [[GTLServiceCalendar alloc] init];
    self.service.authorizer =
    [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kKeychainItemName
                                                          clientID:kClientID
                                                      clientSecret:nil];
    return !self.service.authorizer.canAuthorize;
}

- (void)loginWithGoogleWithTarget:(UIViewController *)target {
    //Initialize the Google Calendar API service & load existing credentials from the keychain if available.
    self.target = target;
    self.service = [[GTLServiceCalendar alloc] init];
    self.service.authorizer =
    [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kKeychainItemName
                                                          clientID:kClientID
                                                      clientSecret:nil];
    if (!self.service.authorizer.canAuthorize) {
        // Not yet authorized, request authorization by pushing the login UI onto the UI stack.
        [self.target presentViewController:[self createAuthControllerWithTarget:self.target] animated:YES completion:nil];
    } else {
        //[self fetchEvents];
        NSLog(@"go next from loginWithGoogleWithTarget");
    }
}

- (void)fetchEventsWithCount:(NSInteger)count minDate:(NSDate *)minDate maxDate:(NSDate *)maxDate {
    self.eventsArray = [NSMutableArray array];
    GTLQueryCalendar *query = [GTLQueryCalendar queryForEventsListWithCalendarId:@"primary"];
    query.maxResults = count;
    query.timeMin = [GTLDateTime dateTimeWithDate:minDate
                                         timeZone:[NSTimeZone localTimeZone]];
    query.timeMax = [GTLDateTime dateTimeWithDate:maxDate
                                         timeZone:[NSTimeZone localTimeZone]];
    query.singleEvents = YES;
    query.orderBy = kGTLCalendarOrderByStartTime;
    
    [self.service executeQuery:query
                      delegate:self
             didFinishSelector:@selector(saveResultWithTicket:finishedWithObject:error:)];
    //    [self.target dismissViewControllerAnimated:YES completion:nil];
}

// Creates the auth controller for authorizing access to Google Calendar API.
- (GTMOAuth2ViewControllerTouch *)createAuthControllerWithTarget:(UIViewController *)target {
    GTMOAuth2ViewControllerTouch *authController;
    // If modifying these scopes, delete your previously saved credentials by
    // resetting the iOS simulator or uninstall the app.
    NSArray *scopes = [NSArray arrayWithObjects:@"https://www.googleapis.com/auth/userinfo.profile",
                       @"https://www.googleapis.com/auth/calendar",
                       @"https://www.googleapis.com/auth/calendar.readonly", nil];
    authController = [[GTMOAuth2ViewControllerTouch alloc]
                      initWithScope:[scopes componentsJoinedByString:@" "]
                      clientID:kClientID
                      clientSecret:nil
                      keychainItemName:kKeychainItemName
                      delegate:self
                      finishedSelector:@selector(viewController:finishedWithAuth:error:)];
    return authController;
}
//[NSArray arrayWithObjects:
//@"https://www.googleapis.com/auth/userinfo.profile",
//@"https://www.googleapis.com/auth/calendar",
//@"https://www.googleapis.com/auth/calendar.readonly",
//nil]
- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)authResult
                 error:(NSError *)error {
    if (error != nil) {
        [self showAlert:@"Authentication Error" message:error.localizedDescription WithTarget:self.target];
        self.service.authorizer = nil;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.target dismissViewControllerAnimated:YES completion:nil];
        });
    }
    else {
        self.service.authorizer = authResult;
        //NSLog(@"authResult.parameters -> %@", [self dictToJson:authResult.parameters]);
        [NFSyncManager sharedManager].userId = [self getUserId];
        [self.target dismissViewControllerAnimated:YES completion:nil];
    }
}

// Helper for showing an alert
- (void)showAlert:(NSString *)title message:(NSString *)message WithTarget:(UIViewController *)target {
    UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:title
                                        message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok =
    [UIAlertAction actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * action)
     {
         [alert dismissViewControllerAnimated:YES completion:nil];
     }];
    [alert addAction:ok];
    [self.target presentViewController:alert animated:YES completion:nil];
    
}

- (void)logOutWithTarget:(id)target{
    [GTMOAuth2ViewControllerTouch removeAuthFromKeychainForName:kKeychainItemName];
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
//                                @"Main" bundle:[NSBundle mainBundle]];
//    NFLoginSimpleController *splashController = [storyboard instantiateViewControllerWithIdentifier:@"NFLoginSimpleController"];
//    UIViewController *vc = target;
    self.service = nil;
//    [vc presentViewController:splashController animated:YES completion:nil];
}

- (NSString *)getUserId {
    GTMOAuth2Authentication *user = self.service.fetcherService.authorizer;
    NSLog(@"user info ---> %@",user.userID);
    return user.userID;
}



- (NSString *)getGoogleToken {
    GTMOAuth2Authentication *user = self.service.fetcherService.authorizer;
    NSLog(@"google token %@", [user.parameters objectForKey:@"refresh_token"]);
    return [user.parameters objectForKey:@"refresh_token"];
}

- (void)saveResultWithTicket:(GTLServiceTicket *)ticket
          finishedWithObject:(GTLCalendarEvents *)events
                       error:(NSError *)error {
    if (error == nil) {
        [self.eventsArray removeAllObjects];
        for (GTLCalendarEvent *event in events) {
          //  NSLog(@"event %@", event.summary);
            if (event) {
                [self.eventsArray addObject:[self NFEventFromGoogle:event]];
            }
        }
        NSNotification *notification = [NSNotification notificationWithName:GOOGLE_NOTIF object:self];
        [[NSNotificationCenter defaultCenter]postNotification:notification];
    }
}

- (NSString *)dictToJson:(NSDictionary *)dict {
    NSError * err;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&err];
    NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return myString;
}

- (NFEvent *)NFEventFromGoogle:(GTLCalendarEvent *)googleEvent {
    NFEvent *event = [[NFEvent alloc]  init];
    NSLog(@"Google event %@", googleEvent.JSON);
    event.title = [googleEvent.JSON objectForKey:@"summary"];
    event.eventDescription = [googleEvent.JSON objectForKey:@"description"];
    event.createDate = [[googleEvent.JSON objectForKey:@"created"] substringToIndex:19];
    
    if ([[googleEvent.JSON objectForKey:@"start"] objectForKey:@"dateTime"]) {
        event.startDate = [[[googleEvent.JSON objectForKey:@"start"] objectForKey:@"dateTime"] substringToIndex:19];
    } else if ([[googleEvent.JSON objectForKey:@"start"] objectForKey:@"date"]) {
        event.startDate =[NSString stringWithFormat:@"%@T00:01:00",[[googleEvent.JSON objectForKey:@"start"] objectForKey:@"date"] ];
    } else {
        event.startDate = [[googleEvent.JSON objectForKey:@"created"] substringToIndex:19];
    }
    
    if ([[googleEvent.JSON objectForKey:@"end"] objectForKey:@"dateTime"]) {
        event.endDate = [[[googleEvent.JSON objectForKey:@"end"] objectForKey:@"dateTime"] substringToIndex:19];
    } else if ([[googleEvent.JSON objectForKey:@"end"] objectForKey:@"date"]) {
        event.endDate =  [NSString stringWithFormat:@"%@T00:01:00",[[googleEvent.JSON objectForKey:@"end"] objectForKey:@"date"]];
    } else  {
        event.endDate = [[googleEvent.JSON objectForKey:@"created"] substringToIndex:19];
    }
    
    event.eventType = Event;
    event.socialType = GoogleEvent;
    //event.eventId = [googleEvent.JSON objectForKey:@"id"];
    event.socialId = [googleEvent.JSON objectForKey:@"id"];
    NSLog(@"start %@ name %@", event.startDate, event.title);
    [googleEvent setSummary:@"NEW EVENT FROM APP"];
    
    return event;
}

- (void)loadLoginScreenWithController:(id)controller {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
                                @"Main" bundle:[NSBundle mainBundle]];
    NFLoginSimpleController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"NFLoginSimpleController"];
    UINavigationController *navController = [storyboard instantiateViewControllerWithIdentifier:@"UINaVLogin"];
    [navController setViewControllers:@[viewController]];
    [controller presentViewController:navController animated:YES completion:nil];
}

- (void)addEventToGoogleCalendar:(NFEvent*)event {
    
    GTLCalendarEvent* calendarEvent = [[GTLCalendarEvent alloc] init];
    [calendarEvent setSummary:event.title];
    [calendarEvent setDescriptionProperty:event.eventDescription];
    NSDate *startDate = [self dateFromString:event.startDate];
    NSDate *endDate = [self dateFromString:event.endDate];
    GTLDateTime *startTime = [GTLDateTime dateTimeWithDate:startDate
                                                  timeZone:[NSTimeZone defaultTimeZone]];
    [calendarEvent setStart:[GTLCalendarEventDateTime object]];
    [calendarEvent.start setDateTime:startTime];
    GTLDateTime *endTime = [GTLDateTime dateTimeWithDate:endDate
                                                timeZone:[NSTimeZone defaultTimeZone]];
    [calendarEvent setEnd:[GTLCalendarEventDateTime object]];
    [calendarEvent.end setDateTime:endTime];
    GTLQueryCalendar *insertQuery = [GTLQueryCalendar queryForEventsInsertWithObject:calendarEvent
                                                                          calendarId:@"shitikov.net@gmail.com"];
    NSLog(@"Adding Event…?????");
    
    [self.service executeQuery:insertQuery
                 completionHandler:^(GTLServiceTicket *ticket, id object, NSError *error) {
                     if (error == nil) {
                         if ([object isKindOfClass:[GTLCalendarEvent class]]) {
                             GTLCalendarEvent *eventGoogle = object;
//                             NFEvent *eventNesia = [NFEvent new];
                             //eventNesia = event;
                             event.socialId = [eventGoogle.JSON objectForKey:@"id"];
                             [[NFSyncManager sharedManager] writeEventToFirebase:event];
                         }
                         NSLog(@"Adding Event…");
                         
                     } else {
                         NSLog(@"Event Entry Failed");
                     }
                 }];
}




- (void)writEventToGoogle:(NFEvent*)event {
    //[GTLQueryCalendar queryForEventsInsertWithObject:yourEventObject calendarId:yourCalendarId];
}

//- (void)writeEvents {
//    GTLCalendarEvent *event = [GTLCalendarEvent new];
//    
//    // 予定のタイトル
//    [event setSummary:@"イベント"];
//    
//    // 予定の説明
//    [event setDescriptionProperty:@"created by google calendar sample"];
//    
//    // 予定の日時を指定する準備
//    NSDateFormatter *dateFormatter = [NSDateFormatter new];
//    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
//    
//    // 予定の開始日時
//    GTLDateTime *startDateTime = [GTLDateTime dateTimeWithDate:[dateFormatter dateFromString:@"2015/07/19 11:00:00"] timeZone:[NSTimeZone systemTimeZone]];
//    GTLCalendarEventDateTime *start = [GTLCalendarEventDateTime new];
//    [start setDateTime:startDateTime];
//    [start setTimeZone:@"Asia/Tokyo"];
//    [event setStart:start];
//    
//    // 予定の終了日時
//    GTLDateTime *endDateTime = [GTLDateTime dateTimeWithDate:[dateFormatter dateFromString:@"2015/07/19 15:00:00"] timeZone:[NSTimeZone systemTimeZone]];
//    GTLCalendarEventDateTime *end = [GTLCalendarEventDateTime new];
//    [end setDateTime:endDateTime];
//    [end setTimeZone:@"Asia/Tokyo"];
//    [event setEnd:end];
//    
//    //
//    GTLQueryCalendar *query = [GTLQueryCalendar queryForEventsInsertWithObject:event calendarId:@"shitikov.net@gmail.com"];
//    
//    [self.service executeQuery:query
//             completionHandler:^(GTLServiceTicket *ticket, id object, NSError *error) {
//                 NSLog(@"object = %@ error = %@", object, error);
//             }];
//}
//

- (void)addAnEvent {
    // Make a new event, and show it to the user to edit
    GTLCalendarEvent *newEvent = [GTLCalendarEvent object];
    newEvent.summary = @"Added  today";
    newEvent.descriptionProperty = @"Description of sample added event";
    
    // We'll set the start time to now, and the end time to an hour from now,
    // with a reminder 10 minutes before
    NSDate *anHourFromNow = [NSDate dateWithTimeIntervalSinceNow:60*60];
    GTLDateTime *startDateTime = [GTLDateTime dateTimeWithDate:[NSDate date]
                                                      timeZone:[NSTimeZone systemTimeZone]];
    GTLDateTime *endDateTime = [GTLDateTime dateTimeWithDate:anHourFromNow
                                                    timeZone:[NSTimeZone systemTimeZone]];
    
    newEvent.start = [GTLCalendarEventDateTime object];
    newEvent.start.dateTime = startDateTime;
    
    newEvent.end = [GTLCalendarEventDateTime object];
    newEvent.end.dateTime = endDateTime;
    
//    GTLCalendarEventReminder *reminder = [GTLCalendarEventReminder object];
//    reminder.minutes = [NSNumber numberWithInteger:10];
//    reminder.method = @"email";
    
//    newEvent.reminders = [GTLCalendarEventReminders object];
//    newEvent.reminders.overrides = [NSArray arrayWithObject:reminder];
//    newEvent.reminders.useDefault = [NSNumber numberWithBool:NO];
    NSLog(@"new event id %@", newEvent.identifier);
    [self addEvent:newEvent];
}


- (void)addEvent:(GTLCalendarEvent *)event {
    GTLQueryCalendar *query = [GTLQueryCalendar queryForEventsInsertWithObject:event
                                                                    calendarId:@"shitikov.net@gmail.com"];
    [self.service executeQuery:query
             completionHandler:^(GTLServiceTicket *ticket, id object, NSError *error) {
                 NSLog(@"");
             }];
}

- (void)displayAddEventResultWithTicket:(GTLServiceTicket *)ticket
                     finishedWithObject:(GTLCalendarEvents *)events
                                  error:(NSError *)error {
    if (error == nil) {
        NSLog(@"I think event has been added successfully!");
        
    } else {
        NSLog(@"ERROR : %@", error.localizedDescription);
    }
}

- (NSDate *)dateFromString:(NSString*)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *dateFromString = [dateFormatter dateFromString:dateString];
    return dateFromString;
}


@end
