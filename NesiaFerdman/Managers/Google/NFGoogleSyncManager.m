//
//  NFGoogleSyncManager.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 7/20/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFGoogleSyncManager.h"
#import "NFSettingManager.h"
#import "NFNSyncManager.h"
#import "NFFirebaseSyncManager.h"

#define APP_CALENDAR_NAME @"Коуч ежедневик"
#define ITEMS_KEY @"items"


@interface NFGoogleSyncManager () <GIDSignInDelegate, GIDSignInUIDelegate>

@property (strong, nonatomic) NSMutableArray *googleEventsArray;
@property (strong, nonatomic) NSMutableArray *googleCalendarsArray;
@property (assign, nonatomic) BOOL isCalendarsDownloadComplite;
@property (assign, nonatomic) BOOL isEventsDownloadComplite;

@property (nonatomic, strong) GTLRCalendarService *service;
@property (strong, nonatomic) GIDSignIn* signIn;
@property (assign, nonatomic) NSInteger calendarsRequestCount;

@end

@implementation NFGoogleSyncManager

#pragma mark -  Init methods

+ (NFGoogleSyncManager*)sharedManager {
    static NFGoogleSyncManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _googleEventsArray = [NSMutableArray array];
        _googleCalendarsArray = [NSMutableArray array];
        _isEventsDownloadComplite = false;
        _isCalendarsDownloadComplite = false;
        
        _signIn = [GIDSignIn sharedInstance];
        _signIn.delegate = self;
        _signIn.scopes = [NSArray arrayWithObjects:kGTLRAuthScopeCalendarReadonly, kGTLRAuthScopeCalendar, nil];
        [_signIn signInSilently];
        self.service = [[GTLRCalendarService alloc] init];
    }
    return self;
}


#pragma mark - get methods

- (NSMutableArray<NFGoogleCalendar*>*)getCalendarList {
    return _googleCalendarsArray;
}

- (NSMutableArray<NFNEvent*>*)getEventList {
    return _googleEventsArray;
}


#pragma mark - GIDSignInDelegate

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    if (error != nil) {
        self.service.authorizer = nil;
        NSLog(@"Not Login");
    } else {
        self.service.authorizer = user.authentication.fetcherAuthorizer;
        NSLog(@"Login");
        [GIDSignIn sharedInstance].clientID = [FIRApp defaultApp].options.clientID;
        GIDAuthentication *authentication = user.authentication;
        FIRAuthCredential *credential =
        [FIRGoogleAuthProvider credentialWithIDToken:authentication.idToken
                                         accessToken:authentication.accessToken];
        [[FIRAuth auth] signInWithCredential:credential completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
            if (error == nil) {
                NSLog(@"singin to firebase");
                
            } else {
                NSLog(@"not login to firebase");
            }
        }];
    }
}

#pragma mark - Authorization

- (void)loginActionWithTarget:(id)target {
    _signIn.uiDelegate = target;
    [[GIDSignIn sharedInstance] signIn];
}

- (void)logOutAction {
    NSError *signOutError;
    [[FIRAuth auth] signOut:&signOutError];
    [[GIDSignIn sharedInstance] signOut];
}

- (BOOL)isLogin {
    return [[GIDSignIn sharedInstance] hasAuthInKeychain];
}

#pragma mark - google api

- (void)addNewEvent:(NFNEvent*)event {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *calendarId = [defaults valueForKey:APP_GOOGLE_CALENDAR_ID];
    GTLRCalendarQuery_EventsInsert *query = [GTLRCalendarQuery_EventsInsert queryWithObject:[event toGoogleEvent] calendarId:calendarId];
    [self.service executeQuery:query
             completionHandler:^(GTLRServiceTicket * _Nonnull callbackTicket, id  _Nullable object, NSError * _Nullable callbackError) {
                 GTLRCalendar_Event *new = object;
                 NFNGoogleEvent *googleEvent = [[NFNGoogleEvent alloc] initWithDictionary:new.JSON];
                 event.socialId = googleEvent.idField;
                 event.socialType = NGoogleEvent;
                 event.calendarID = calendarId;
                 NSLog(@"write event to google");
                 [[NFNSyncManager sharedManager] addEventToDBManager:event];
                 [[NFNSyncManager sharedManager] writeEventToDataBase:event];
                 [[NFNSyncManager sharedManager] updateDataSource];
             }];
}

- (void)updateEvent:(NFNEvent*)event {
    
}

- (void)deleteEvent:(NFNEvent*)event {
    
}

- (void)downloadGoogleEventsListWithCalendarsArray:(NSArray*)array {
    [_googleEventsArray removeAllObjects];
    _calendarsRequestCount = array.count;
    
    for (NFGoogleCalendar *calendar in array) {
        NSString *calendarColor = calendar.backgroundColor;
        GTLRCalendarQuery_EventsList *query = [GTLRCalendarQuery_EventsList queryWithCalendarId:calendar.idField];
        query.maxResults = 1000;
        query.timeMin = [GTLRDateTime dateTimeWithDate: [NFSettingManager getMinDate]];
        query.timeMax = [GTLRDateTime dateTimeWithDate: [NFSettingManager getMaxDate]];
        query.singleEvents = YES;
        query.orderBy = kGTLRCalendarOrderByStartTime;
        [self.service executeQuery:query
                 completionHandler:^(GTLRServiceTicket * _Nonnull callbackTicket, id  _Nullable object, NSError * _Nullable callbackError) {
                     GTLRCalendar_Events *eventsList = object;
                     NSMutableArray *itemsDic = [NSMutableArray new];
                     [itemsDic addObjectsFromArray: [[eventsList.JSON objectForKey:ITEMS_KEY] allObjects]];
                     for (NSDictionary *dic in itemsDic) {
                         NFNEvent *nesiaEvent = [[NFNEvent alloc] initWithGoogleEvent:[[NFNGoogleEvent alloc] initWithDictionary:dic]];
                         nesiaEvent.calendarColor = calendarColor;
                         [_googleEventsArray addObject:nesiaEvent];
                     }
                     _calendarsRequestCount --;
                     if (_calendarsRequestCount == 0) {
                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                             NSNotification *notification = [NSNotification notificationWithName:NOTIFYCATIN_EVENT_LOAD object:nil];
                             [[NSNotificationCenter defaultCenter] postNotification:notification];
                         });
                     }
                 }];
    }
}

- (void)downloadGoogleCalendarList {
    [_googleCalendarsArray removeAllObjects];
    GTLRCalendarQuery_CalendarListList *query = [GTLRCalendarQuery_CalendarListList query];
    [self.service executeQuery:query
             completionHandler:^(GTLRServiceTicket * _Nonnull callbackTicket, id  _Nullable object, NSError * _Nullable callbackError) {
                 if (callbackError == nil) {
                     if([object isKindOfClass:[GTLRCalendar_CalendarList class]]) {
                         GTLRCalendar_CalendarList *list = object;
                         NSMutableArray *calendrsID = [NSMutableArray array];
                         [calendrsID addObjectsFromArray: [list.JSON objectForKey:ITEMS_KEY]];
                         
                         for (NSDictionary *dic in calendrsID) {
                             NFGoogleCalendar *calendar = [[NFGoogleCalendar alloc] initWithDictionary:dic];
                             NSLog(@"google Calendar %@", calendar.summary);
                             [_googleCalendarsArray addObject:calendar];
                         }
                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                             [self chackAPPCalendar];
                             NSNotification *notification = [NSNotification notificationWithName:NOTIFYCATIN_CALENDAR_LIST_LOAD object:nil];
                             [[NSNotificationCenter defaultCenter] postNotification:notification];
                         });
                     }
                 }
             }];
}

- (void)chackAPPCalendar {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *calendarID = [defaults valueForKey:APP_GOOGLE_CALENDAR_ID];
    int i = 0;
    for (NFGoogleCalendar *calendar in _googleCalendarsArray) {
        if ([calendar.idField isEqualToString:calendarID]) {
            i++;
            break;
        }
    }
    i > 0 ? nil: [self createAppGoogleCalendar];
}

- (void)createAppGoogleCalendar {
    GTLRCalendar_Calendar *newCalendar = [[GTLRCalendar_Calendar alloc] init];
    newCalendar.summary = APP_CALENDAR_NAME;
    GTLRCalendarQuery_CalendarsInsert *query = [GTLRCalendarQuery_CalendarsInsert queryWithObject:newCalendar];
    [self.service executeQuery:query
             completionHandler:^(GTLRServiceTicket * _Nonnull callbackTicket, id  _Nullable object, NSError * _Nullable callbackError) {
                 if (callbackError == nil) {
                     NSLog(@"calendar new %@", object);
                     GTLRCalendar_Calendar *cal = object;
                     NFGoogleCalendar *new = [[NFGoogleCalendar alloc] initWithDictionary:cal.JSON];
                     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                     [defaults setValue:new.idField forKey:APP_GOOGLE_CALENDAR_ID];
                     NSLog(@"create new calendar");
                 }
             }];
}




@end
