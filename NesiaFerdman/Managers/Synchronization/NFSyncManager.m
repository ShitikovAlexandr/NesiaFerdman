//
//  NFSyncManager.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 4/26/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFSyncManager.h"
#import "NotifyList.h"
#import "NFSettingManager.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "Reachability.h"




@interface NFSyncManager()


//Adding a flag for download managers
@property (assign, nonatomic) BOOL googleIsFinished;
@property (assign, nonatomic) BOOL firebaseIsFinished;
@property (assign, nonatomic) BOOL phoneIsFinished;

@end

@implementation NFSyncManager

+ (NFSyncManager *)sharedManager {
    static NFSyncManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        //init all arrays for data
        self.eventsArray = [NSMutableArray array];
//        self.googleEvents = [NSMutableArray array];
//        self.firebaseEvents = [NSMutableArray array];
//        self.phoneEvents = [NSMutableArray array];
        self.valuesArray = [NSMutableArray array];
        
        // while phone sinc not include in app
        self.phoneIsFinished = YES;
        
        //get acces to firebase
        [[NFFirebaseManager sharedManager] getAccessToFirebase];
        
        //get acces to iPhoneCalendar
        //[[NFPhoneManager sharedManager] getAccess];

        
        //get the user id as a key for entry into the database (google id in this case)
        self.userId = [[NFGoogleManager sharedManager] getUserId];
        
        
        //Add a notification to determine the end of the data download manager
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(googleFinishedLoadData) name:GOOGLE_NOTIF object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(firebaseFinishedLoadData) name:FIREBASE_NOTIF object:nil];
        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(phoneFinishedLoadData) name:PHONE_NOTIF object:nil];
        
    }
    return self;
}

+ (BOOL)connectedInternet
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

- (void)addStandartListOfValue {
    [[NFFirebaseManager sharedManager] addStandartListOfValuesToDateBaseWithUserId:_userId];
}

- (void)addStandartListOfMainifestations {
    [[NFFirebaseManager sharedManager] addSatndartListOfManifestations];
}

- (void)addStandartListOfResultCategory {
    [[NFFirebaseManager sharedManager] addStandartListOfResultCategoryToDateBase];
}

- (void)writeNewEventWithSetting:(NFEvent*)event {
    if (![NFSyncManager connectedInternet]) {
        [NFPop startAlertWithMassage:@"Проверте интернет соединение!!!"];
    }
    
    if ([NFSettingManager isOnGoogleSync]) {
        if ([NFSettingManager isOnWriteToGoogle]) {
            event.socialType = GoogleEvent;
            [self writeEventToGoogle:event];
            
        } else {
            event.socialType = NesiaEvent;
            [self writeEventToFirebase:event];
        }
        
    } else {
        event.socialType = NesiaEvent;
        [self writeEventToFirebase:event];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[NFSyncManager sharedManager]  updateAllData];
    });
}

- (void)editEventWithSetting:(NFEvent*)event {
    if ([NFSettingManager isOnGoogleSync]) {
        if ([NFSettingManager isOnWriteToGoogle]) {
            if (event.socialType == GoogleEvent) {
                [self updateEventInGoogleWithEvent:event];
            } else {
                [self writeEventToFirebase:event];
            }
        } else {
            [self writeEventToFirebase:event];
        }
    } else {
        [self writeEventToFirebase:event];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[NFSyncManager sharedManager]  updateAllData];
    });
}

- (void)deleteEventWithSetting:(NFEvent*)event {
    if ([NFSettingManager isOnGoogleSync]) {
        if ([NFSettingManager isOnDeleteFromGoogle]) {
            if (event.socialType == GoogleEvent) {
                [self deleteEventFromGoogle:event];
            } else {
                [self deleteEventFromFirebase:event];
            }
        } else {
            [self deleteEventFromFirebase:event];
        }
        
    } else {
        [self deleteEventFromFirebase:event];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[NFSyncManager sharedManager]  updateAllData];
    });
}

//Methods of downloading/uploading the data managers

//Firebase---------

- (void)getEventsFromFirebase {
    
    [[NFFirebaseManager sharedManager].firebaseEventsArray removeAllObjects];
    [[NFFirebaseManager sharedManager] getDataFromFirebase];
    [[NFFirebaseManager sharedManager] getMinSyncInterval];
    [[NFFirebaseManager sharedManager] getMaxSyncInterval];
    //[[NFFirebaseManager sharedManager] addStandartListOfValuesToDateBaseWithUserId:@"XXX"];
}

- (void)writeEventToFirebase:(NFEvent *)event {
    [[NFFirebaseManager sharedManager] writeEventToFirebase:event withUserId:_userId];
   
}

- (void)deleteEventFromFirebase:(NFEvent *)event {
    //[[NFFirebaseManager sharedManager] deleteEventFromFirebase:event withUserId:_userId];
    event.isDeleted = true;
    [[NFFirebaseManager sharedManager] writeEventToFirebase:event withUserId:_userId];
}

//- (void)getValuesFromFirebase {
//    [[NFFirebaseManager sharedManager] getAllValues];
//}

- (void)writeValueToFirebase:(NFValue *)value {
    [[NFFirebaseManager sharedManager] addValue:value withUserId:_userId];
}

- (void)writeResultToFirebase:(NFResult*)result {
    [[NFFirebaseManager sharedManager] addResult:result withUserId:_userId];
}

- (void)updateAllResults {
    [[NFFirebaseManager sharedManager] getAllResultsWithUserId:_userId];
}

- (void)deleteValueFromFirebase:(NFValue *)value {
    value.isDeleted = true;
    [self writeValueToFirebase:value];
//    [[NFFirebaseManager sharedManager] deleteValue:value withUserId:_userId];
}
//----------------

//GoogleCalendar---------

- (void)getEventsFromGoogleCalendar {
//    NSDate *endDate = [NSDate dateWithTimeIntervalSinceNow:8000000];
//    NSDate *startDate = [NSDate dateWithTimeIntervalSinceNow:-8000000];
    [[NFGoogleManager sharedManager] fetchEventsWithCount:5000 minDate:[NFSettingManager getMinDate]
                                                  maxDate:[NFSettingManager getMaxDate]];
}
//_______________________

//iPhone Calendar

//- (void)getEventsFromPhone {
//    NSDate *endDate = [NSDate dateWithTimeIntervalSinceNow:8000000];
//    NSDate *startDate = [NSDate dateWithTimeIntervalSinceNow:-8000000];
//    [[NFPhoneManager sharedManager] getAllEvents];
//}

- (void)updateAllData {
    [self getEventsFromFirebase];
    [self getEventsFromGoogleCalendar];
    //[self getEventsFromPhone];
}

- (void)phoneFinishedLoadData {
    self.phoneIsFinished = YES;
    [self loadingIsComplete];
}

- (void)googleFinishedLoadData {
    self.googleIsFinished = YES;
    [self loadingIsComplete];
}

- (void)firebaseFinishedLoadData {
    self.firebaseIsFinished = YES;
    [self loadingIsComplete];
}

- (void)loadingIsComplete {
    if (_firebaseIsFinished && _googleIsFinished /*&& _phoneIsFinished*/) {
        //[self clearAllData];
        //[self.firebaseEvents addObjectsFromArray:[NFFirebaseManager sharedManager].firebaseEventsArray];
        [self.valuesArray removeAllObjects];
        [self.valuesArray  addObjectsFromArray:[NFFirebaseManager sharedManager].valuesArray];
        _firebaseIsFinished = NO;
        _googleIsFinished = NO;
        _phoneIsFinished = NO;
        //[self addStandartListOfMainifestations];
        [self filterEvents];
    }
}

- (void)updateResults {
    [[NFFirebaseManager sharedManager] getAllResultsWithUserId:_userId];
    [[NFTaskManager sharedManager].resultsArray addObjectsFromArray:[NFFirebaseManager sharedManager].resultsArray];
}

- (void)filterEvents {
    [self.eventsArray removeAllObjects];
    [self.eventsArray addObjectsFromArray:[NFFirebaseManager sharedManager].firebaseEventsArray]; // new
    [self.eventsArray addObjectsFromArray:[self addEventWithFilterFromArray:[NFGoogleManager sharedManager].eventsArray]];
    
    [[NFTaskManager sharedManager] addAllEventsFromArray:[self filterDeleteEvents:self.eventsArray]];
    [[NFTaskManager sharedManager].valuesArray removeAllObjects];
    [[NFTaskManager sharedManager].resultCategoryArray removeAllObjects];
    [[NFTaskManager sharedManager].resultCategoryArray addObjectsFromArray: [self sortArray:[NFFirebaseManager sharedManager].resultCategoryArray withKey:@"resultCategoryIndex"]];
    
    [[NFTaskManager sharedManager].resultsArray removeAllObjects];
    [[NFTaskManager sharedManager].resultsArray  addObjectsFromArray:[NFFirebaseManager sharedManager].resultsArray];
    
    //[[NFTaskManager sharedManager].valuesArray addObjectsFromArray:[self sortArray:self.valuesArray withKey:@"valueIndex"]];
    [[NFTaskManager sharedManager].valuesArray addObjectsFromArray: [self sincUserValues:self.valuesArray withBaseValues:[NFFirebaseManager sharedManager].baseValuesArray]];
    
    [[NFTaskManager sharedManager].manifestationsArray removeAllObjects];
    [[NFTaskManager sharedManager].manifestationsArray addObjectsFromArray:[NFFirebaseManager sharedManager].manifestationsArray];
    
    NSNotification *notification = [NSNotification notificationWithName:END_UPDATE_DATA object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
//    [self clearAllData];
}

- (NSMutableArray *)addEventWithFilterFromArray:(NSMutableArray*)eventsArray {
    NSMutableArray *tempInputArray = [NSMutableArray array];
    [tempInputArray addObjectsFromArray:eventsArray];
    NSMutableArray *equalsEvent = [NSMutableArray array];
    if (tempInputArray.count > 0) {
        for (NFEvent *NesiaEvent in self.eventsArray) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.socialId contains[c] %@", NesiaEvent.socialId];
            [equalsEvent addObjectsFromArray:[tempInputArray filteredArrayUsingPredicate:predicate]];
            NSLog(@"equalsEvent predicate count %ld", (unsigned long)[tempInputArray filteredArrayUsingPredicate:predicate].count);
            [self updateEvent:NesiaEvent withModifiedEvent:[[tempInputArray filteredArrayUsingPredicate:predicate] firstObject]];
        }
        for (NFEvent *event in equalsEvent) {
            [tempInputArray removeObject:event];
        }
        for (NFEvent *newEvent in tempInputArray) {
            [[NFFirebaseManager sharedManager] writeEventToFirebase:newEvent withUserId:[[NFGoogleManager sharedManager]  getUserId]];
        }
    }
    return tempInputArray;
}

- (void)updateEvent:(NFEvent*)event withModifiedEvent:(NFEvent*)modifed {
    if (modifed) {
        if (![event.dateChange isEqualToString:modifed.dateChange]) {
            event.dateChange = modifed.dateChange;
            event.title = modifed.title;
            event.startDate = modifed.startDate;
            event.endDate = modifed.endDate;
            event.createDate = modifed.createDate;
             [[NFFirebaseManager sharedManager] writeEventToFirebase:event withUserId:[[NFGoogleManager sharedManager]  getUserId]];
        }
        NSLog(@"new %@", modifed.title);
    } else {
        NSLog(@"no");
    }
}

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

- (void)clearAllData {
    [self.valuesArray removeAllObjects];
    [self.eventsArray removeAllObjects];
    [[NFGoogleManager sharedManager].eventsArray removeAllObjects];
    [[NFFirebaseManager sharedManager].firebaseEventsArray removeAllObjects];
}

- (NSMutableArray*)sortArray:(NSMutableArray *)array withKey:(NSString*)key {
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    return (NSMutableArray*)[array sortedArrayUsingDescriptors:sortDescriptors];
}

- (NSMutableArray*)sincUserValues:(NSMutableArray*)userValues withBaseValues:(NSMutableArray*)baseValues {
    NSMutableArray *tempInputArray = [NSMutableArray array];
    [tempInputArray addObjectsFromArray:baseValues];
    NSMutableArray *equalsEvent = [NSMutableArray array];
    if (tempInputArray.count > 0) {
        for (NFValue *value in userValues) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.valueId contains[c] %@", value.valueId];
            [equalsEvent addObjectsFromArray:[tempInputArray filteredArrayUsingPredicate:predicate]];
        }
        for (NFValue *value in equalsEvent) {
            [tempInputArray removeObject:value];
        }
        for (NFValue *newVALUE in tempInputArray) {
            [[NFFirebaseManager sharedManager] addValue:newVALUE withUserId:_userId];
        }
        
    }
    [userValues addObjectsFromArray:tempInputArray];
    return [self sortArray:userValues withKey:@"valueIndex"];
}

- (NSMutableArray*)filterDeleteEvents:(NSMutableArray*)array {
    NSMutableArray* result = [NSMutableArray array];
    [result addObjectsFromArray:array];
    for (NFEvent* event in array) {
        if (event.isDeleted) {
            [result removeObject:event];
            NSLog(@"deleted event %@ %@", event.eventId, event.title);
        }
    }
    return result;
}
//-----------

- (void)writeEventToGoogle:(NFEvent*)event {
    [[NFGoogleManager sharedManager] addEventToGoogleCalendar:event];
}

- (void)updateEventInGoogleWithEvent:(NFEvent*)event {
    [[NFGoogleManager sharedManager] updateGoogleEventWith:event];
}

- (void)deleteEventFromGoogle:(NFEvent*)event {
    event.isDeleted = true;
    [[NFGoogleManager sharedManager] deleteGoogleEventWithEvent:event];
}




@end
