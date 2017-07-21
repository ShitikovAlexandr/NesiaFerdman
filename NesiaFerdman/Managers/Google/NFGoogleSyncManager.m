//
//  NFGoogleSyncManager.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 7/20/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFGoogleSyncManager.h"
#import "NFGoogleCalendar.h"
#import "NFSettingManager.h"


@interface NFGoogleSyncManager () <GIDSignInDelegate, GIDSignInUIDelegate>

@property (strong, nonatomic) NSMutableArray *googleEventsArray;
@property (strong, nonatomic) NSMutableArray *googleCalendarsArray;
@property (assign, nonatomic) BOOL isCalendarsDownloadComplite;
@property (assign, nonatomic) BOOL isEventsDownloadComplite;

@property (nonatomic, strong) GTLRCalendarService *service;
@property (strong, nonatomic) GIDSignIn* signIn;

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
            NSLog(@"singin to firebase");
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
    return false;
#warning isLogin method empty
}

- (NSString*)getUserId {
    return @"";
#warning getUserId method is empty
}

#pragma mark - google api

- (void)addNewEvent:(NFEvent*)event {
    GTLRCalendar_Event *googleEvent = [[GTLRCalendar_Event alloc] init];
#warning set current event
    GTLRCalendarQuery_EventsInsert *query = [GTLRCalendarQuery_EventsInsert queryWithObject:googleEvent calendarId:@"primary"];
    [self.service executeQuery:query
             completionHandler:^(GTLRServiceTicket * _Nonnull callbackTicket, id  _Nullable object, NSError * _Nullable callbackError) {
                 NSLog(@"write event to google");
             }];
}

- (void)updateEvent:(NFEvent*)event {
    
}

- (void)deleteEvent:(NFEvent*)event {
    
}

- (void)loadGoogleEventsListWithCalendarsArray:(NSArray*)array {
    [_googleEventsArray removeAllObjects];
    
    for (NFGoogleCalendar *calendar in array) {
        GTLRCalendarQuery_EventsList *query = [GTLRCalendarQuery_EventsList queryWithCalendarId:calendar.idField];
        query.maxResults = 1000;
        query.timeMin = [GTLRDateTime dateTimeWithDate: [NFSettingManager getMinDate]];
        query.timeMax = [GTLRDateTime dateTimeWithDate: [NFSettingManager getMaxDate]];
        query.singleEvents = YES;
        query.orderBy = kGTLRCalendarOrderByStartTime;
        [self.service executeQuery:query
                 completionHandler:^(GTLRServiceTicket * _Nonnull callbackTicket, id  _Nullable object, NSError * _Nullable callbackError) {
                     NSLog(@"Events list %@", object);
                     GTLRCalendar_Event *googleEvent = object;
                     NFEvent *event = [[NFEvent alloc] initWithGoogleEventDictionary:googleEvent.JSON];
                     [_googleEventsArray addObject:event];
                 }];
    }
}

- (void)loadGoogleCalendarList {
    [_googleCalendarsArray removeAllObjects];
    GTLRCalendarQuery_CalendarListList *query = [GTLRCalendarQuery_CalendarListList query];
    [self.service executeQuery:query
             completionHandler:^(GTLRServiceTicket * _Nonnull callbackTicket, id  _Nullable object, NSError * _Nullable callbackError) {
                 if (callbackError == nil) {
                     if([object isKindOfClass:[GTLRCalendar_CalendarList class]]) {
                         GTLRCalendar_CalendarList *list = object;
                         NSMutableArray *calendrsID = [NSMutableArray array];
                         [calendrsID addObjectsFromArray: [list.JSON objectForKey:@"items"] ];
                         //_calendarCount = calendrsID.count;
                         for (NSDictionary *dic in calendrsID) {
                             NFGoogleCalendar *calendar = [[NFGoogleCalendar alloc] initWithDictionary:dic];
                             [_googleCalendarsArray addObject:calendar];
                         }
                     }
                 }

             }];
}


@end
