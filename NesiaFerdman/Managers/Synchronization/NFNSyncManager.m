//
//  NFNSyncManager.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 7/24/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFNSyncManager.h"
#import "NFFirebaseSyncManager.h"
#import "NFGoogleSyncManager.h"
#import "NFDataSourceManager.h"

@interface NFNSyncManager ()

@property (strong, nonatomic) NSMutableArray *calendarList;
@property (strong, nonatomic) NSMutableArray *eventsList;
@property (strong, nonatomic) NSMutableArray *manifestationList;



@property (assign, nonatomic) BOOL isGogleCalendar;
@property (assign, nonatomic) BOOL isGoogleEvent;
@property (assign, nonatomic) BOOL isDataBase;
@end

@implementation NFNSyncManager

+ (NFNSyncManager *)sharedManager {
    static NFNSyncManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
//    if (![self connectedInternet]) {
//        [NFPop startAlertWithMassage:kErrorInternetconnection];
//    }
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        //Googlle
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(googleCalendarListEndDownload)name:NOTIFYCATIN_CALENDAR_LIST_LOAD object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(googleEventsEndDownload)name:NOTIFYCATIN_EVENT_LOAD object:nil];
        //firebase
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataBaseEndDownload)name:DATA_BASE_COMPLITE_DOWNLOADED_ALL_DATA object:nil];
    }
    return self;
}

- (void)updateData {
    [[NFFirebaseSyncManager sharedManager] downloadAllData];
    [[NFGoogleSyncManager sharedManager] downloadGoogleCalendarList];
}


#pragma mark - sync methods

- (void)googleCalendarListEndDownload {
    _isGogleCalendar = true;
    [self dataSynchronization];
}

- (void)googleEventsEndDownload {
    _isGoogleEvent  = true;
    [self eventsSynchronization];
    [[NFDataSourceManager sharedManager] setEventList:[[NFFirebaseSyncManager sharedManager] getEvensList]];
}

- (void)dataBaseEndDownload {
    _isDataBase = true;
    [self dataSynchronization];
}

- (void)dataSynchronization {
    
    if (_isDataBase && _isGogleCalendar) {
        [self calendarSynchronization];
        [self appValueSynchronization];
        [[NFGoogleSyncManager sharedManager] downloadGoogleEventsListWithCalendarsArray:[self selectedCalendars]];
        _isDataBase = false;
        _isGogleCalendar = false;
        
        [[NFDataSourceManager sharedManager] setResultCategoryList:[[NFFirebaseSyncManager sharedManager] getResultCategoryList]];
        [[NFDataSourceManager sharedManager] setResultList:[[NFFirebaseSyncManager sharedManager] getResultList]];

        [[NFDataSourceManager sharedManager] setValueList:[[NFFirebaseSyncManager sharedManager] getValueList]];
        [[NFDataSourceManager sharedManager] setCalendarList:[[NFFirebaseSyncManager sharedManager] getCalendarList]];
    }
}

- (void)calendarSynchronization {
    NSMutableArray *googleCalendars = [NSMutableArray new];
    NSMutableArray *dataBaseCalendars = [NSMutableArray new];
    [googleCalendars addObjectsFromArray:[[NFGoogleSyncManager sharedManager] getCalendarList]];
    [dataBaseCalendars addObjectsFromArray:[[NFFirebaseSyncManager sharedManager] getCalendarList]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"!(SELF.idField IN %@)", [dataBaseCalendars valueForKey:@"idField"]];
    NSArray* newCalendarsArray = [googleCalendars filteredArrayUsingPredicate:predicate];
    NSLog(@"result new calendars %@", newCalendarsArray);
    
    NSPredicate *removedPredicate = [NSPredicate predicateWithFormat:@"!(SELF.idField IN %@)", [googleCalendars valueForKey:@"idField"]];
    NSArray* removedCalendarsArray = [dataBaseCalendars filteredArrayUsingPredicate:removedPredicate];
    NSLog(@"result removed calendars %@", removedCalendarsArray);

    for (NFGoogleCalendar *calendar in newCalendarsArray) {
        [self writeCalendarToDataBase:calendar];
        [self addCalendarToDBManager:calendar];
    }
    for (NFGoogleCalendar *calendar in removedCalendarsArray) {
        [self removeCalendarFromDB:calendar];
        [self removeCalendarFromDBManager:calendar];
    }
}

- (void)appValueSynchronization {
    NSArray *appValue = [NSArray arrayWithArray:[[NFFirebaseSyncManager sharedManager] getAppValueList]];
    NSArray *userValue = [NSArray arrayWithArray:[[NFFirebaseSyncManager sharedManager] getValueList]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"!(SELF.valueId IN %@)", [userValue valueForKey:@"valueId"]]; //NFNValue
    NSArray *newValue = [appValue filteredArrayUsingPredicate:predicate];
    for (NFNValue *val in newValue) {
        [self addValueToDBManager:val];
        [self writeValueToDataBase:val];
    }
}

- (void)eventsSynchronization {
    
//chack new event from google
    NSMutableArray *googleEvents = [NSMutableArray new];
    NSMutableArray *dataBaseEvents = [NSMutableArray new];
    [googleEvents addObjectsFromArray:[[NFGoogleSyncManager sharedManager] getEventList]];
    [dataBaseEvents addObjectsFromArray:[[NFFirebaseSyncManager sharedManager] getEvensList]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"!(SELF.socialId IN %@)", [dataBaseEvents valueForKey:@"socialId"]];
    NSArray *newEvent = [googleEvents filteredArrayUsingPredicate:predicate];
    for (NFNEvent *event in newEvent) {
        [self addEventToDBManager:event];
        [self writeEventToDataBase:event];
    }
    
// chack if old event did change in google
    NSPredicate *equalDBPredicate = [NSPredicate predicateWithFormat:@"SELF.socialId IN %@ AND !(SELF.updateDate IN %@)",
                                     [googleEvents valueForKey:@"socialId"], [googleEvents valueForKey:@"updateDate"]];
    NSArray *equalDBEvents = [dataBaseEvents filteredArrayUsingPredicate:equalDBPredicate];
    NSLog(@"equalDBEvents %@", equalDBEvents);
    
    NSPredicate *equalGooglePredicate = [NSPredicate predicateWithFormat:@"SELF.socialId IN  %@", [equalDBEvents valueForKey:@"socialId"]];
    NSArray *equalGoogleEvents = [googleEvents filteredArrayUsingPredicate:equalGooglePredicate];
    NSLog(@"equalDBEvents %@", equalGoogleEvents);
    for (NFNEvent *oldEvent in equalDBEvents) {
        for (NFNEvent *newEvent in equalGoogleEvents) {
            if ([oldEvent.socialId isEqualToString:newEvent.socialId]) {
                [oldEvent updateEvent:oldEvent withNewEvent:newEvent];
                [self writeEventToDataBase:oldEvent];
            }
        }
    }
    
// filter deleted evens
    NSPredicate *deletePredicate = [NSPredicate predicateWithFormat:@"SELF.isDeleted == YES"];
    NSArray *deletedItems = [dataBaseEvents filteredArrayUsingPredicate:deletePredicate];
    for (NFNEvent *event in deletedItems) {
        [self removeEventFromDBManager:event];
    }
}

//return selected calendars
- (NSMutableArray*)selectedCalendars {
    NSMutableArray *result = [NSMutableArray new];
    for (NFGoogleCalendar *calendar in [[NFFirebaseSyncManager sharedManager] getCalendarList]) {
        if (calendar.selectedInApp) {
            [result addObject:calendar];
        }
    }
    return result;
}

#pragma mark - data base methods

- (void)writeEventToDataBase:(NFNEvent*)event {
    [[NFFirebaseSyncManager sharedManager] writeEvent:event];
}

- (void)writeValueToDataBase:(NFNValue*)value {
    [[NFFirebaseSyncManager sharedManager] writeValue:value];
}

- (void)writeManifestationToDataBase:(NFNManifestation*)manifestation toValue:(NFNValue*)value {
    [[NFFirebaseSyncManager sharedManager] writeManifestation:manifestation toValue:value];
}

- (void)writeResult:(NFNRsult*)resulte {
    [[NFFirebaseSyncManager sharedManager] writeResult:resulte];
}

- (void)writeCalendarToDataBase:(NFGoogleCalendar*)calendar {
    [[NFFirebaseSyncManager sharedManager] writeCalendar:calendar];
}

- (void)removeCalendarFromDB:(NFGoogleCalendar*)calendar {
    [[NFFirebaseSyncManager sharedManager] deleteCalendar:calendar];
}

- (void)removeEventFromDB:(NFNEvent*)event {
    [[NFFirebaseSyncManager sharedManager] deleteEvent:event];
}

- (void)removeValueFromDB:(NFNValue*)value {
    [[NFFirebaseSyncManager sharedManager] deleteValue:value];
}

- (void)removeManifestationDB:(NFNManifestation*)manifestation {
    [[NFFirebaseSyncManager sharedManager] deleteManifestation:manifestation];
}

- (void)removeResultFromDB:(NFNRsult*)result {
    [[NFFirebaseSyncManager sharedManager] deleteResult:result];
}



- (void)endDownloadData {
    NSLog(@"endDownloadData");
}

#pragma mark - managers methods 

- (void)addCalendarToDBManager:(NFGoogleCalendar*)calendar {
    [[NFFirebaseSyncManager sharedManager] addCalendarToManager:calendar];
}

- (void)addEventToDBManager:(NFNEvent*)event {
    [[NFFirebaseSyncManager sharedManager] addEventToManager:event];
}

- (void)addValueToDBManager:(NFNValue*)value {
    [[NFFirebaseSyncManager sharedManager] addValueToManager:value];
}

- (void)addManifestationToDBManager:(NFNManifestation*)manifestation {
    [[NFFirebaseSyncManager sharedManager] addManifestationToManager:manifestation];
}

- (void)addResultToDBManager:(NFNRsult*)result {
    [[NFFirebaseSyncManager sharedManager] addResultToManager:result];
}

//**********************

- (void)removeCalendarFromDBManager:(NFGoogleCalendar*)calendar {
    [[NFFirebaseSyncManager sharedManager] removeCalendarFromManager:calendar];
}

- (void)removeEventFromDBManager:(NFNEvent*)event {
    [[NFFirebaseSyncManager sharedManager] removeEventFromManager:event];
}

- (void)removeValueFromDBManager:(NFNValue*)value {
    [[NFFirebaseSyncManager sharedManager] removeValueFromManager:value];
}

- (void)removeManifestationDBFromManager:(NFNManifestation*)manifestation {
    [[NFFirebaseSyncManager sharedManager] removeManifestationFromManager:manifestation];
}

- (void)removeResultFromDBManager:(NFNRsult*)result {
    [[NFFirebaseSyncManager sharedManager]  removeResultFromManager:result];
}

#pragma mark - app run methods

- (BOOL)isFirstRunApp {
    NSUserDefaults *defaults = [[NSUserDefaults alloc] init];
    if (![defaults valueForKey:IS_FIRST_RUN_APP]) {
        [defaults setValue:@"no" forKey:IS_FIRST_RUN_APP];
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isFirstRunToday {
    NSUserDefaults *defaults = [[NSUserDefaults alloc] init];
    NSString *dateOfLastRun = [defaults valueForKey:IS_FIRST_RUN_TODAY];
    if (dateOfLastRun) {
        if ([dateOfLastRun isEqualToString:[self stringFromDate:[NSDate date]]]) {
            return NO;
        } else {
            [defaults setValue:[self stringFromDate:[NSDate date]] forKey:IS_FIRST_RUN_TODAY];
            return YES;
        }
    } else {
        [defaults setValue:[self stringFromDate:[NSDate date]] forKey:IS_FIRST_RUN_TODAY];
        return YES;
    }
}

- (NSString *)stringFromDate:(NSDate *)currentDate  {
    NFDateFormatter *dateFormatter1 = [[NFDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
    NSString* newDate = [dateFormatter1 stringFromDate:currentDate];
    return newDate;
}





@end
