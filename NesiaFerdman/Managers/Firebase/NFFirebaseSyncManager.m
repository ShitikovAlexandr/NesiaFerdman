//
//  NFFirebaseSyncManager.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 7/21/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFFirebaseSyncManager.h"

#define USER_UID [[[FIRAuth auth] currentUser] uid]
#define USERS_DIRECTORY @"Users"
#define EVENT_DIRECTORY @"Events"
#define VALUE_DIRECTORY @"Values"
#define RESULT_DIRECTORY @"Results"
#define RESULT_ITEM @"ResultItems"

#define RESULT_CATEGORY @"ResultsCategory"



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



@end
