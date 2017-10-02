//
//  NFNSyncManager.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/24/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFNSyncManager.h"
#import "NFFirebaseSyncManager.h"
#import "NFGoogleSyncManager.h"
#import "NFDataSourceManager.h"
#import "NFSettingManager.h"
#import "NFFirebaseSyncManager.h"
#import "Reachability.h"

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
    return manager;
}

- (void)reset {
    [_calendarList removeAllObjects];
    [_eventsList removeAllObjects];
    [_manifestationList removeAllObjects];
    _isDataBase = false;
    _isGoogleEvent = false;
    _isGogleCalendar = false;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        //Googlle
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(googleCalendarListEndDownload)name:NOTIFYCATIN_CALENDAR_LIST_LOAD object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(googleEventsEndDownload)name:NOTIFYCATIN_EVENT_LOAD object:nil];
        //firebase
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataBaseEndDownload)name:DATA_BASE_COMPLITE_DOWNLOADED_ALL_DATA object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityDidChange:) name:kReachabilityChangedNotification object:nil];
    }
    return self;
}

- (void)reachabilityDidChange:(NSNotification *)notification {
    Reachability *reachability = (Reachability *)[notification object];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    if (networkStatus  == NotReachable) {
        [NFPop startAlertWithMassage:kErrorInternetconnection];
    }
}

+ (BOOL)connectedInternet
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    if (networkStatus  == NotReachable) {
        [NFPop startAlertWithMassage:kErrorInternetconnection];
        return false;
    } else {
        return true;
    }
}

- (void)updateData {
    [[NFFirebaseSyncManager sharedManager] downloadAllData];
    [[NFGoogleSyncManager sharedManager] downloadGoogleCalendarList];
}

- (void)updateFIRToken:(NSString*)token {
    [[NFFirebaseSyncManager sharedManager] writePushToken:token];
}


#pragma mark - sync methods

- (void)googleCalendarListEndDownload {
    _isGogleCalendar = true;
    [self dataSynchronization];
}

- (void)googleEventsEndDownload {
    _isGoogleEvent  = true;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self eventsSynchronization];
        [[NFDataSourceManager sharedManager] setEventList:[[NFFirebaseSyncManager sharedManager] getEvensList]];
    });
    
}

- (void)dataBaseEndDownload {
    _isDataBase = true;
    [self dataSynchronization];
}

- (void)dataSynchronization {
    
    if (_isDataBase && _isGogleCalendar) {
        [self manifestationsSynchronization];
        [self calendarSynchronization];
        [self appValueSynchronization];
        [[NFGoogleSyncManager sharedManager] downloadGoogleEventsListWithCalendarsArray:[self selectedCalendars]];
        _isDataBase = false;
        _isGogleCalendar = false;
        
        [[NFDataSourceManager sharedManager] setResultCategoryList:[[NFFirebaseSyncManager sharedManager] getResultCategoryList]];
        [[NFDataSourceManager sharedManager] setResultList:[[NFFirebaseSyncManager sharedManager] getResultList]];
        
        [[NFDataSourceManager sharedManager] setValueList:[[NFFirebaseSyncManager sharedManager] getValueList]];
        [[NFDataSourceManager sharedManager] setCalendarList:[[NFFirebaseSyncManager sharedManager] getCalendarList]];
        [[NFDataSourceManager sharedManager] setManifestationList:[[NFFirebaseSyncManager sharedManager] getUseManifestationList]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSNotification *notification = [NSNotification notificationWithName:END_UPDATE object:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        });
    }
}

- (void)manifestationsSynchronization {
    NSMutableArray *appManifestation  = [NSMutableArray new];
    NSMutableArray *userManifestations = [NSMutableArray new];
    [appManifestation addObjectsFromArray:[[NFFirebaseSyncManager sharedManager] getAppManifestationList]];
    [userManifestations addObjectsFromArray:[[NFFirebaseSyncManager sharedManager] getUseManifestationList]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"!(SELF.idField IN %@)", [userManifestations valueForKey:@"idField"]];
    NSArray *newManifestation = [appManifestation filteredArrayUsingPredicate:predicate];
    
    for (NFNManifestation *item in newManifestation) {
        NFNValue *val = [[NFNValue alloc] init];
        val.valueId = item.parentId;
        [self writeManifestationToDataBase:item toValue:val];
        [self addManifestationToDBManager:item];
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
    [self updateCalendarListInfoFromOld:dataBaseCalendars toNew:googleCalendars];
    
}

- (void)updateCalendarListInfoFromOld:(NSArray*)oldList toNew:(NSArray*)newList {
    for (NFGoogleCalendar *oldCalendar in oldList) {
        for (NFGoogleCalendar *newCalendar in newList) {
            if ([oldCalendar.idField isEqualToString:newCalendar.idField]) {
                [oldCalendar updateInfoFromCalendar:newCalendar];
                [[NFFirebaseSyncManager sharedManager] writeCalendar:oldCalendar];
            }
        }
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
    [[NFDataSourceManager sharedManager] removeEventFromDataSource:event];
}

- (void)removeValueFromDB:(NFNValue*)value {
    [[NFFirebaseSyncManager sharedManager] deleteValue:value];
    [[NFDataSourceManager sharedManager] removeValueFromDataSource:value];
}

- (void)removeManifestationDB:(NFNManifestation*)manifestation {
    [[NFFirebaseSyncManager sharedManager] deleteManifestation:manifestation];
    [[NFDataSourceManager sharedManager] removeManifestationFromDataSource:manifestation];
}

- (void)removeResultFromDB:(NFNRsult*)result {
    [[NFFirebaseSyncManager sharedManager] deleteResult:result];
    [[NFDataSourceManager sharedManager] removeResultFromDataSource:result];
}

#pragma mark - managers methods

- (void)addCalendarToDBManager:(NFGoogleCalendar*)calendar {
    [[NFDataSourceManager sharedManager] addCalendarToDataSource:calendar];
    [[NFFirebaseSyncManager sharedManager] addCalendarToManager:calendar];
}

- (void)addEventToDBManager:(NFNEvent*)event {
    [[NFFirebaseSyncManager sharedManager] addEventToManager:event];
    [[NFDataSourceManager sharedManager] addEventToDataSource:event];
}

- (void)addValueToDBManager:(NFNValue*)value {
    [[NFFirebaseSyncManager sharedManager] addValueToManager:value];
    [[NFDataSourceManager sharedManager] addValueToDataSource:value];
}

- (void)addManifestationToDBManager:(NFNManifestation*)manifestation {
    [[NFFirebaseSyncManager sharedManager] addManifestationToManager:manifestation];
    [[NFDataSourceManager sharedManager] addManifestationToDataSource:manifestation];
}

- (void)addResultToDBManager:(NFNRsult*)result {
    [[NFDataSourceManager sharedManager] addResultToDataSource:result];
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
    [[NFDataSourceManager sharedManager] removeResultFromDataSource:result];
    [[NFFirebaseSyncManager sharedManager]  removeResultFromManager:result];
}

- (void)resetSelectedValuesList {
    [[NFDataSourceManager sharedManager] resetSelectedValueList];
}

- (void)addValuesToSelectedList:(NSArray*)array {
    [[NFDataSourceManager sharedManager] addValuesToSelectedList:array];
}

//*********************************

//google

- (void)addNewEventToGoogle:(NFNEvent*)event {
    [[NFGoogleSyncManager sharedManager] addNewEvent:event];
}

- (void)deleteEventFromGoogle:(NFNEvent*)event {
    [[NFGoogleSyncManager sharedManager] deleteEvent:event];
}

- (void)updateGoogleEvent:(NFNEvent*)event {
    [[NFGoogleSyncManager sharedManager] updateEvent:event];
}

#pragma mark - app run methods

- (BOOL)isFirstRunApp {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *runValue = [defaults valueForKey:IS_FIRST_RUN_APP];
    if (![runValue isEqualToString:FIRST_RUN_FLAG]) {
        [defaults setValue:FIRST_RUN_FLAG forKey:IS_FIRST_RUN_APP];
        [defaults setValue:[self stringFromDate:[NSDate date]] forKey:IS_FIRST_RUN_TODAY];
        [defaults synchronize];
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

- (void)filterEventsWithActiveValue {
//    //NFNValue
    NSArray *allValues = [NSArray arrayWithArray:[[NFDataSourceManager sharedManager] getAllValueList]];
    NSPredicate *notActiveValuePredicate = [NSPredicate predicateWithFormat:@"SELF.isDeleted == YES"];
    NSArray *notActiveValue = [allValues filteredArrayUsingPredicate:notActiveValuePredicate];
    
    //NFNEvent
    NSArray *allEvents = [NSArray arrayWithArray:[[NFDataSourceManager sharedManager] getEventList]];
       NSPredicate *eventsWithNoActiveValuePredicate = [NSPredicate predicateWithFormat:@"ANY SELF.values.valueId IN %@", [notActiveValue valueForKey:@"valueId"]];
    NSArray *resultEventArray = [allEvents filteredArrayUsingPredicate:eventsWithNoActiveValuePredicate];
    NSLog(@"resultEventArray %@", resultEventArray);
    for (NFNEvent *event in resultEventArray) {
        NSMutableArray *tempValue = [NSMutableArray arrayWithArray:event.values];
        for (NFNValue *val in tempValue) {
            for (NFNValue *noActiveVal in notActiveValue) {
                if ([noActiveVal.valueId isEqualToString:val.valueId]) {
                    [event.values removeObject:val];
                }
            }
        }
        [[NFNSyncManager sharedManager] writeEventToDataBase:event];
    }
}

- (void)updateDataSource {
    [[NFDataSourceManager sharedManager] setResultCategoryList:[[NFFirebaseSyncManager sharedManager] getResultCategoryList]];
    [[NFDataSourceManager sharedManager] setResultList:[[NFFirebaseSyncManager sharedManager] getResultList]];
    [[NFDataSourceManager sharedManager] setValueList:[[NFFirebaseSyncManager sharedManager] getValueList]];
    [[NFDataSourceManager sharedManager] setCalendarList:[[NFFirebaseSyncManager sharedManager] getCalendarList]];
    [[NFDataSourceManager sharedManager] setEventList:[[NFFirebaseSyncManager sharedManager] getEvensList]];
}

- (void)updateValueDataSource {
    [[NFDataSourceManager sharedManager] setValueList:[[NFFirebaseSyncManager sharedManager] getValueList]];
}

- (void)updateManifestationDataSource {
    [[NFDataSourceManager sharedManager] setManifestationList:[[NFFirebaseSyncManager sharedManager] getUseManifestationList]];
}

- (NSMutableArray*)sortArray:(NSMutableArray *)array withKey:(NSString*)key {
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    return (NSMutableArray*)[array sortedArrayUsingDescriptors:sortDescriptors];
}

- (NSArray*)getQuotesList {
    return  [[NFFirebaseSyncManager sharedManager] getQuoteList];
}

- (void)deleteUser {
    [[NFFirebaseSyncManager sharedManager] deleteUser];
}


@end
