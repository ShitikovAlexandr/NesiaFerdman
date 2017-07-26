//
//  NFFirebaseSyncManager.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 7/21/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//





#import "NFFirebaseSyncManager.h"
#import "NFAdminManager.h"


//ref keys
#define USER_UID [[[FIRAuth auth] currentUser] uid]
#define USERS_DIRECTORY             @"Users"
#define EVENT_DIRECTORY             @"Events"
#define VALUE_DIRECTORY             @"Values"
#define MANIFESTATION_DIRECTORY     @"Manifestations"
#define RESULT_DIRECTORY            @"Results"
#define RESULT_ITEM                 @"ResultItems"
#define RESULT_CATEGORY             @"ResultsCategory"
#define CALENDAR_LIST               @"Calendars"

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

@property (strong, nonatomic) NSMutableArray *appManifestationArray;


@property (assign, nonatomic) BOOL isEventsList;
@property (assign, nonatomic) BOOL isValueList;
@property (assign, nonatomic) BOOL isValuesManifestations;
@property (assign, nonatomic) BOOL isResult;
@property (assign, nonatomic) BOOL isCalendarList;

@property (assign, nonatomic) BOOL isAppValueList;
@property (assign, nonatomic) BOOL isAppResultCategory;
@property (assign, nonatomic) BOOL isAppManifestatioms;





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
        _appManifestationArray = [NSMutableArray new];
    }
    return self;
}




#pragma mark - get methods

- (void)downloadAllData {
    if ([self isLogin]) {
        [self downloadEvensList];
        [self downloadCalendarList];
        [self downloadValueList];
        [self downloadManifestationList];
        [self downloadResiltList];
        
        [self downloadAppValueList];
        [self downloadAppResultCategory];
        [self downloadAppManifestationList];
    } else {
        NSLog(@"not login firebase");
    }
}

- (NSMutableArray*)getEvensList {
    return _eventsArray;
}

- (NSMutableArray*)getValueList {
    return _valueArray;
}

- (NSMutableArray*)getUseManifestationList {
    return _valuesManifestationsArray;
}

- (NSMutableArray*)getResultList {
    return _resultsArray;
}

- (NSMutableArray*)getCalendarList {
    return _googleCalendarsArray;
}

- (NSMutableArray*)getAppValueList {
    return _appValuesArray;
}

- (NSMutableArray*)getResultCategoryList {
    return _appResultsArray;
}

- (NSMutableArray*)getAppManifestationList {
    return _appManifestationArray;
}

//************************************************************************

- (void)addCalendarToManager:(NFGoogleCalendar*)calendar {
    [_googleCalendarsArray addObject:calendar];
}

- (void)addEventToManager:(NFNEvent*)event {
    [_eventsArray addObject:event];
}

- (void)addValueToManager:(NFNValue*)value {
    [_valueArray addObject:value];
}

- (void)addManifestationToManager:(NFNManifestation*)manifestation {
    [_valuesManifestationsArray addObject:manifestation];
}

- (void)addResultToManager:(NFNRsult*)result {
    [_resultsArray addObject:result];
}

//************************************************************************

- (void)removeCalendarFromManager:(NFGoogleCalendar*)calendar {
    [_googleCalendarsArray removeObject:calendar];
}

- (void)removeEventFromManager:(NFNEvent*)event {
    [_eventsArray removeObject:event];
}

- (void)removeValueFromManager:(NFNValue*)value {
    [_valueArray removeObject:value];
}

- (void)removeManifestationFromManager:(NFNManifestation*)manifestation {
    [_valuesManifestationsArray removeObject:manifestation];
}

- (void)removeResultFromManager:(NFNRsult*)result {
    [_resultsArray removeObject:result];
}

//************************************************************************

- (void)downloadEvensList {
    [[self eventRef] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSMutableArray *inputArray = [NSMutableArray array];
        NSEnumerator *children = [snapshot children];
        FIRDataSnapshot *child;
        while (child = [children nextObject]) {
            NSDictionary *itemDictionary = [NSDictionary dictionaryWithDictionary:(NSDictionary*)child.value];
            [inputArray addObject:itemDictionary];
        }
        NSMutableArray *resultArray = [NSMutableArray new];
        for (NSDictionary* dic in inputArray) {
            NFNEvent *newObject = [[NFNEvent alloc] initWithDictionary:dic];
            [resultArray addObject:newObject];
        }
        [_eventsArray removeAllObjects];
        [_eventsArray addObjectsFromArray:resultArray];
        _isEventsList = true;
        [self downloadComplite];
       
    }];
}

- (void)downloadResiltList {
    [[self userResultRef] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSMutableArray *inputArray = [NSMutableArray array];
        NSEnumerator *children = [snapshot children];
        FIRDataSnapshot *child;
        while (child = [children nextObject]) {
            NSDictionary *itemDictionary = [NSDictionary dictionaryWithDictionary:(NSDictionary*)child.value];
            [inputArray addObject:itemDictionary];
        }
        NSMutableArray *resultArray = [NSMutableArray new];
        for (NSDictionary* dic in inputArray) {
            NFNRsult *newObject = [[NFNRsult alloc] initWithDictionary:dic];
            [resultArray addObject:newObject];
        }
        [_resultsArray removeAllObjects];
        [_resultsArray addObjectsFromArray:resultArray];
        _isResult = true;
        [self downloadComplite];
        
    }];

}

- (void)downloadCalendarList {
    [[self userCalendarsRef] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSMutableArray *inputArray = [NSMutableArray array];
        NSEnumerator *children = [snapshot children];
        FIRDataSnapshot *child;
        while (child = [children nextObject]) {
            NSDictionary *itemDictionary = [NSDictionary dictionaryWithDictionary:(NSDictionary*)child.value];
            [inputArray addObject:itemDictionary];
        }
        NSMutableArray *resultArray = [NSMutableArray new];
        for (NSDictionary* dic in inputArray) {
            NFGoogleCalendar *newObject = [[NFGoogleCalendar alloc] initWithDictionary:dic];
            [resultArray addObject:newObject];
        }
        [_googleCalendarsArray removeAllObjects];
        [_googleCalendarsArray addObjectsFromArray:resultArray];
        _isCalendarList = true;
        [self downloadComplite];
    }];
}

- (void)downloadValueList {
    [[self userValueRef] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSMutableArray *inputArray = [NSMutableArray array];
        NSEnumerator *children = [snapshot children];
        FIRDataSnapshot *child;
        while (child = [children nextObject]) {
            NSDictionary *itemDictionary = [NSDictionary dictionaryWithDictionary:(NSDictionary*)child.value];
            [inputArray addObject:itemDictionary];
        }
        NSMutableArray *resultArray = [NSMutableArray new];
        for (NSDictionary* dic in inputArray) {
            NFNValue *newObject = [[NFNValue alloc] initWithDictionary:dic];
            [resultArray addObject:newObject];
        }
        [_valueArray removeAllObjects];
        [_valueArray addObjectsFromArray:resultArray];
        _isValueList = true;
        [self downloadComplite];
    }];
}

- (void)downloadManifestationList {
    [[self userValueManifestationsRef] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSMutableArray *inputArray = [NSMutableArray array];
        NSEnumerator *children = [snapshot children];
        FIRDataSnapshot *child;
        while (child = [children nextObject]) {
            NSDictionary *itemDictionary = [NSDictionary dictionaryWithDictionary:(NSDictionary*)child.value];
            [inputArray addObject:itemDictionary];
        }
        NSMutableArray *resultArray = [NSMutableArray new];
        for (NSDictionary* dic in inputArray) {
            NFNManifestation *newObject = [[NFNManifestation alloc] initWithDictionary:dic];
            [resultArray addObject:newObject];
        }
        [_valuesManifestationsArray removeAllObjects];
        [_valuesManifestationsArray addObjectsFromArray:resultArray];
        _isValuesManifestations = true;
        [self downloadComplite];
    }];
}


#pragma mark - app data

- (void)downloadAppValueList {
    [[self appValuesRef] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSMutableArray *inputArray = [NSMutableArray array];
        NSEnumerator *children = [snapshot children];
        FIRDataSnapshot *child;
        while (child = [children nextObject]) {
            NSDictionary *itemDictionary = [NSDictionary dictionaryWithDictionary:(NSDictionary*)child.value];
            [inputArray addObject:itemDictionary];
        }
        NSMutableArray *resultArray = [NSMutableArray new];
        for (NSDictionary* dic in inputArray) {
            NFNValue *newObject = [[NFNValue alloc] initWithDictionary:dic];
            [resultArray addObject:newObject];
        }
        [_appValuesArray removeAllObjects];
        [_appValuesArray addObjectsFromArray:resultArray];
        _isAppValueList = true;
        [self downloadComplite];
    }];
}

- (void)downloadAppManifestationList {
    [[self appValueManifestationsRef] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSMutableArray *inputArray = [NSMutableArray array];
        NSEnumerator *children = [snapshot children];
        FIRDataSnapshot *child;
        while (child = [children nextObject]) {
            NSDictionary *itemDictionary = [NSDictionary dictionaryWithDictionary:(NSDictionary*)child.value];
            [inputArray addObject:itemDictionary];
        }
        NSMutableArray *resultArray = [NSMutableArray new];
        for (NSDictionary* dic in inputArray) {
            NFNManifestation *newObject = [[NFNManifestation alloc] initWithDictionary:dic];
            [resultArray addObject:newObject];
        }
        [_appManifestationArray removeAllObjects];
        [_appManifestationArray addObjectsFromArray:resultArray];
        _isAppManifestatioms = true;
        [self downloadComplite];
    }];
}

- (void)downloadAppResultCategory {
    [[self appResultCategoryRef] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSMutableArray *inputArray = [NSMutableArray array];
        NSEnumerator *children = [snapshot children];
        FIRDataSnapshot *child;
        while (child = [children nextObject]) {
            NSDictionary *itemDictionary = [NSDictionary dictionaryWithDictionary:(NSDictionary*)child.value];
            [inputArray addObject:itemDictionary];
        }
        NSMutableArray *resultArray = [NSMutableArray new];
        for (NSDictionary* dic in inputArray) {
            NFNRsultCategory *newObject = [[NFNRsultCategory alloc] initWithDictionary:dic];
            [resultArray addObject:newObject];
        }
        [_appResultsArray removeAllObjects];
        [_appResultsArray addObjectsFromArray:resultArray];
        _isAppResultCategory = true;
        [self downloadComplite];
    }];

}


#pragma mark - write methods

- (void)writeEvent:(NFNEvent*)event {
    [[[self eventRef] child:event.eventId] updateChildValues:[[event copy] toDictionary] withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        NSLog(@"Complite write event");
    }];
    
}

- (void)writeValue:(NFNValue*)value {
    [[[self userValueRef] child:value.valueId] updateChildValues:[[value copy] toDictionary] withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        NSLog(@"Complite write user value");
    }];
    
}

- (void)writeManifestation:(NFNManifestation*)manifestation toValue:(NFNValue*)value {
    manifestation.parentId = value.valueId;
    [[[self userValueManifestationsRef] child:value.valueId] updateChildValues:[[manifestation copy] toDictionary] withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        NSLog(@"Complite write manifestation");
    }];
}

- (void)writeResult:(NFNRsult*)result {
    [[[self userResultRef] child:result.idField] updateChildValues:[[result copy] toDictionary] withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        NSLog(@"Complite write result");
    }];
}

- (void)writeCalendar:(NFGoogleCalendar*)calendar {
    [[[self userCalendarsRef] child:calendar.appId] updateChildValues:[[calendar copy] toDictionary]];
}

#pragma mark - delete methods

- (void)deleteEvent:(NFNEvent*)event {
    event.isDeleted = true;
    [self writeEvent:event];
}

- (void)deleteValue:(NFNValue*)value {
    value.isDeleted = true;
    [self writeValue:value];
}

- (void)deleteManifestation:(NFNManifestation*)manifestation {
    [[[self userValueManifestationsRef] child:manifestation.idField] removeValue];
}

- (void)deleteResult:(NFNRsult*)result {
    [[[self userResultRef] child:result.idField] removeValue];
}

- (void)deleteCalendar:(NFGoogleCalendar*)calendar {
    [[[self userCalendarsRef] child:calendar.appId] removeValue];
}

#pragma mark - helpers

- (void)downloadComplite {
    NSLog(@"complite download FIR");
    if (_isEventsList && _isValueList && _isValuesManifestations && _isResult && _isCalendarList ) {
        if (_isAppValueList && _isAppResultCategory && _isAppManifestatioms) {
            [self resetFlags];
            NSNotification *notification = [NSNotification notificationWithName:DATA_BASE_COMPLITE_DOWNLOADED_ALL_DATA object:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }
    }
}

- (void)resetFlags {
    _isEventsList = false;
    _isValueList = false;
    _isValuesManifestations = false;
    _isResult = false;
    _isCalendarList = false;
    _isAppValueList = false;
    _isAppResultCategory = false;
    _isAppManifestatioms = false;
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
    return [[[[self ref] child:USERS_DIRECTORY] child:USER_UID] child:RESULT_DIRECTORY];
}

- (FIRDatabaseReference*)userValueManifestationsRef {
    return [[[[self ref] child:USERS_DIRECTORY] child:USER_UID] child:MANIFESTATION_DIRECTORY];
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

- (FIRDatabaseReference*)appValueManifestationsRef {
    return [[self ref] child:MANIFESTATION_DIRECTORY];
}

- (BOOL)isLogin {
    if ([FIRAuth auth].currentUser != nil) {
        return true;
    } else {
        return false;
    }
}

#pragma mark - admin

- (void)writAppValueToDataBase:(NFNValue*)value {
    [[[self appValuesRef] child:value.valueId] updateChildValues:[value toDictionary]];
}

- (void)writeAppResultCategoryToDataBase:(NFNRsultCategory*)resultCategory {
    [[[self appResultCategoryRef] child:resultCategory.idField] updateChildValues:[resultCategory toDictionary]];
}

- (void)writeAppManifestation:(NFNManifestation*)manifestation toValue:(NFNValue*)value {
    manifestation.parentId = value.valueId;
    [[[self appValueManifestationsRef] child:manifestation.idField] updateChildValues:[manifestation toDictionary]];
}



@end
