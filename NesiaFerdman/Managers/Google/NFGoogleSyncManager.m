//
//  NFGoogleSyncManager.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 7/20/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFGoogleSyncManager.h"


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
#warning loadGoogleEventsListWithCalendarsArray bad params for request
    GTLRCalendarQuery_EventsList *query =
    [GTLRCalendarQuery_EventsList queryWithCalendarId:@"primary"];
    query.maxResults = 1000;
    query.timeMin = [GTLRDateTime dateTimeWithDate:[[NSDate date] dateByAddingTimeInterval:-80000]];
    query.singleEvents = YES;
    query.orderBy = kGTLRCalendarOrderByStartTime;
    
    [self.service executeQuery:query
             completionHandler:^(GTLRServiceTicket * _Nonnull callbackTicket, id  _Nullable object, NSError * _Nullable callbackError) {
                 NSLog(@"Events list %@", object);
             }];

    
}

- (void)loadGoogleCalendarList {
    [_googleCalendarsArray removeAllObjects];
#warning loadGoogleCalendarList method not save data
    GTLRCalendarQuery_CalendarListList *query = [GTLRCalendarQuery_CalendarListList query];
    [self.service executeQuery:query
             completionHandler:^(GTLRServiceTicket * _Nonnull callbackTicket, id  _Nullable object, NSError * _Nullable callbackError) {
                 NSLog(@"Calendars list %@", object);
             }];

}


@end
