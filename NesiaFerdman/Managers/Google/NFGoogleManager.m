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
#import "NFSettingManager.h"

static NSString *const kKeychainItemName = @"Google Calendar API";
static NSString *const kClientID = @"270949290072-8d4197i3nk6hvk1774a1heghuskugo3m.apps.googleusercontent.com";
static NSString *const kAppCalendar = @"Nesia Ferdman";

@interface NFGoogleManager()
@property (strong, nonatomic) UIViewController *target;
@property (assign, nonatomic) BOOL isLastCalendar;
@property (assign, nonatomic) NSInteger calendarCount;
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

- (instancetype)init {
    self = [super init];
    if (self) {
        self.eventsArray = [NSMutableArray array];
    }
    return self;
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

- (void)getCalendarsItemsWithCount:(NSInteger)count minDate:(NSDate *)minDate maxDate:(NSDate *)maxDate {
    GTLQueryCalendar *query = [GTLQueryCalendar queryForCalendarListList];
    [self.service executeQuery:query
             completionHandler:^(GTLServiceTicket *ticket, id object, NSError *error) {
                 if (error == nil) {
                     if([object isKindOfClass:[GTLCalendarCalendarList class]]) {
                         GTLCalendarCalendarList *list = object;
                         NSMutableArray *calendrsID = [NSMutableArray array];
                         [calendrsID addObjectsFromArray: [list.JSON objectForKey:@"items"] ];
                         _calendarCount = calendrsID.count;
                         for (NSDictionary *dic in calendrsID) {
                             NSLog(@"calendar id %@", [dic objectForKey:@"id"]);
                             GTLQueryCalendar *query = [GTLQueryCalendar queryForEventsListWithCalendarId:[dic objectForKey:@"id"]];
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
                         }
                     }
                 }
             }];
}

- (void)fetchEventsWithCount:(NSInteger)count minDate:(NSDate *)minDate maxDate:(NSDate *)maxDate {
    [self.eventsArray removeAllObjects];
    if ([NFSettingManager isOnGoogleSync]) {
        [self getCalendarsItemsWithCount:count minDate:minDate maxDate:maxDate];
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSNotification *notification = [NSNotification notificationWithName:GOOGLE_NOTIF object:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        });
           }
    
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
    self.service = nil;
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
        for (GTLCalendarEvent *event in events) {
            if (event) {
                [self.eventsArray addObject:[self NFEventFromGoogle:event]];
            }
        }
        _calendarCount--;
        if (_calendarCount == 0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSNotification *notification = [NSNotification notificationWithName:GOOGLE_NOTIF object:nil];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            });
        }
    }
}


- (NFEvent *)NFEventFromGoogle:(GTLCalendarEvent *)googleEvent {
    NFEvent *event = [[NFEvent alloc]  init];
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
    //updated
    event.eventType = Event;
    event.socialType = GoogleEvent;
    event.dateChange = [googleEvent.JSON objectForKey:@"updated"];
    event.calendarId = [[googleEvent.JSON objectForKey:@"organizer"] objectForKey:@"email"];
    //event.eventId = [googleEvent.JSON objectForKey:@"id"];
    event.socialId = [googleEvent.JSON objectForKey:@"id"];
    NSLog(@"start %@ name %@", event.startDate, event.title);
    NSLog(@"event name %@ calendar id %@", event.title, event.calendarId);
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

#pragma mark - Read/Write Google events

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
                                                                          calendarId:@"primary"];
    
    [self.service executeQuery:insertQuery
             completionHandler:^(GTLServiceTicket *ticket, id object, NSError *error) {
                 if (error == nil) {
                     if ([object isKindOfClass:[GTLCalendarEvent class]]) {
                         GTLCalendarEvent *eventGoogle = object;
                         event.socialId = [eventGoogle.JSON objectForKey:@"id"];
                     }
                     NSLog(@"Adding Event…");
                     
                 } else {
                     NSLog(@"Event Entry Failed");
                 }
                 [[NFSyncManager sharedManager] writeEventToFirebase:event];
             }];
}

- (void)updateGoogleEventWith:(NFEvent*)event {
    //queryForEventsUpdateWithObject
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
    
    GTLQueryCalendar *editQuery = [GTLQueryCalendar queryForEventsUpdateWithObject:calendarEvent
                                                                        calendarId:event.calendarId
                                                                           eventId:event.socialId];
    [self.service executeQuery:editQuery
             completionHandler:^(GTLServiceTicket *ticket, id object, NSError *error) {
                 if (error == nil) {
                     NSLog(@"edit complite");
                 } else {
                     
                 }
                 [[NFSyncManager sharedManager] writeEventToFirebase:event];
             }];
}

- (void)deleteGoogleEventWithEvent:(NFEvent*)event {
    //queryForEventsDeleteWithCalendarId
    GTLQueryCalendar *deleteQuery = [GTLQueryCalendar queryForEventsDeleteWithCalendarId:event.calendarId eventId:event.socialId];
    [self.service executeQuery:deleteQuery
             completionHandler:^(GTLServiceTicket *ticket, id object, NSError *error) {
                 if (error == nil) {
                     NSLog(@"deleted from google");
                     [[NFSyncManager sharedManager] deleteEventFromFirebase:event];
                     
                 } else {
                     NSLog(@"ERROR deleted from google");
                     [[NFSyncManager sharedManager] deleteEventFromFirebase:event];
                 }
             }];
}

#pragma mark - Helpers

- (NSDate *)dateFromString:(NSString*)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *dateFromString = [dateFormatter dateFromString:dateString];
    return dateFromString;
}

- (NSString *)dictToJson:(NSDictionary *)dict {
    NSError * err;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&err];
    NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return myString;
}



@end
