//
//  NFFirebaseSyncManager.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 7/21/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFFirebaseSyncManager.h"


//ref keys
#define USER_UID [[[FIRAuth auth] currentUser] uid]
#define USERS_DIRECTORY @"Users"
#define EVENT_DIRECTORY @"Events"
#define VALUE_DIRECTORY @"Values"
#define RESULT_DIRECTORY @"Results"
#define RESULT_ITEM @"ResultItems"
#define RESULT_CATEGORY @"ResultsCategory"
#define CALENDAR_LIST @"Calendars"
//notify keys
#define FIREBASE_COMPLITE_LOAD @"kFireDownlownComplite"


@interface NFFirebaseSyncManager ()
@property (strong, nonatomic) FIRDatabaseReference *ref;

//user data
@property (strong, nonatomic) NSMutableArray *eventsArray;
@property (strong, nonatomic) NSMutableArray *valueArray;
@property (strong, nonatomic) NSMutableArray *valuesManifestationsArray;
@property (strong, nonatomic) NSMutableArray *resultsArray;
@property (strong, nonatomic) NSMutableArray *googleCalendarsArray;

// app data
@property (strong, nonatomic) NSMutableArray *appValuesArray;
@property (strong, nonatomic) NSMutableArray *appResultsArray;

// is user data end loaded
@property (assign, nonatomic) BOOL isDownloadEvents;
@property (assign, nonatomic) BOOL isDownloadValues;
@property (assign, nonatomic) BOOL isDownloadvaluesManifestations;
@property (assign, nonatomic) BOOL isDownloadResults;
@property (assign, nonatomic) BOOL isDownloadGoogleCalendars;

// is app data end loaded
@property (assign, nonatomic) BOOL isDownloadAppResults;
@property (assign, nonatomic) BOOL isDownloadAppValues;

@end

@implementation NFFirebaseSyncManager

#pragma mark - init methods

+ (NFFirebaseSyncManager*)sharedManager {
    static NFFirebaseSyncManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _ref = [[FIRDatabase database] reference];
        _eventsArray = [NSMutableArray new];
        _valueArray = [NSMutableArray new];
        _valuesManifestationsArray = [NSMutableArray new];
        _resultsArray = [NSMutableArray new];
        _googleCalendarsArray = [NSMutableArray new];
        _appValuesArray = [NSMutableArray new];
        _appResultsArray = [NSMutableArray new];
    }
    return self;
}

#pragma mark - get methods

- (void)loadAllData {
    if ([self isLogin]) {
        NSLog(@"load all data from firebase");
    } else {
        NSLog(@"not login in firebase");
    }
}

- (void)getEvensList {
    
}

- (void)getValuesList {
    
}

- (void)getValuesManifestationsList {
    
}

- (void)getResultsList {
    
}

- (void)getGoogleCalendarList {
    
}

- (void)getAppValuesList {
    
}

- (void)getAppResultsList {
    
}


#pragma mark - write methods

- (void)writeEvent:(NFNEvent*)event {
    [[[self eventRef] child:event.eventId] updateChildValues:[event toDictionary]];
    
}

- (void)writeValue:(id)value {
    
}

- (void)writeManifestation {
    
}

- (void)writeResult:(id)result {
    
}

- (void)writeCalendar:(NFGoogleCalendar*)calendar {
    [[[self userCalendarsRef] child:calendar.appId] updateChildValues:[calendar toDictionary]];
}

#pragma mark - helpers

- (void)cmpliteLoadAllData {
    // set observer
}



#pragma mark - FIR Data Reference

// User ref
- (FIRDatabaseReference*)eventRef {
    return [[[[self ref] child:USERS_DIRECTORY] child:USER_UID] child:EVENT_DIRECTORY];
}

- (FIRDatabaseReference*)userValueRef {
    return [[[[self ref] child:USERS_DIRECTORY] child:USER_UID] child:VALUE_DIRECTORY];
}

- (FIRDatabaseReference*)userResultRef {
    return [[[[self ref] child:USERS_DIRECTORY] child:USER_UID] child:VALUE_DIRECTORY];
}

- (FIRDatabaseReference*)userValueManifestationsRef {
    return [[[[self ref] child:USERS_DIRECTORY] child:USER_UID] child:VALUE_DIRECTORY];
}

- (FIRDatabaseReference*)userCalendarsRef {
    return [[[[self ref] child:USERS_DIRECTORY] child:USER_UID] child:CALENDAR_LIST];
}

- (FIRDatabaseReference*)userResultItemRef {
    return [[[[self ref] child:USERS_DIRECTORY] child:USER_UID] child:RESULT_ITEM];
}

// App ref
- (FIRDatabaseReference*)appValuesRef {
    return [[self ref] child:VALUE_DIRECTORY];
}

- (FIRDatabaseReference*)appResultCategoryRef {
    return [[self ref] child:RESULT_CATEGORY];
}

- (BOOL)isLogin {
    if ([FIRAuth auth].currentUser != nil) {
        return true;
    } else {
        return false;
    }
}



@end
