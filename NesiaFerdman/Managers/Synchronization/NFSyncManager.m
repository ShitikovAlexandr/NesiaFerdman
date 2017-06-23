//
//  NFSyncManager.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 4/26/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFSyncManager.h"
#import "NotifyList.h"

@interface NFSyncManager()
//@property (strong ,nonatomic) NSMutableArray *googleEvents;
//@property (strong, nonatomic) NSMutableArray *firebaseEvents;
//@property (strong, nonatomic) NSMutableArray *phoneEvents;

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

- (void)addStandartListOfValue {
    [[NFFirebaseManager sharedManager] addStandartListOfValuesToDateBaseWithUserId:_userId];
}

- (void)addStandartListOfResultCategory {
    [[NFFirebaseManager sharedManager] addStandartListOfResultCategoryToDateBase];
}



//Methods of downloading/uploading the data managers


//Firebase---------

- (void)getEventsFromFirebase {
    
    [[NFFirebaseManager sharedManager].firebaseEventsArray removeAllObjects];
    [[NFFirebaseManager sharedManager] getDataFromFirebase];
    //[[NFFirebaseManager sharedManager] addStandartListOfValuesToDateBaseWithUserId:@"XXX"];
}

- (void)writeEventToFirebase:(NFEvent *)event {
    [[NFFirebaseManager sharedManager] writeEventToFirebase:event withUserId:_userId];
   
}

- (void)deleteEventFromFirebase:(NFEvent *)event {
    [[NFFirebaseManager sharedManager] deleteEventFromFirebase:event withUserId:_userId];
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
    NSDate *endDate = [NSDate dateWithTimeIntervalSinceNow:8000000];
    NSDate *startDate = [NSDate dateWithTimeIntervalSinceNow:-8000000];
    [[NFGoogleManager sharedManager] fetchEventsWithCount:100 minDate:startDate maxDate:endDate];
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
    
    [[NFTaskManager sharedManager] addAllEventsFromArray:self.eventsArray];
    [[NFTaskManager sharedManager].valuesArray removeAllObjects];
    [[NFTaskManager sharedManager].resultCategoryArray removeAllObjects];
    [[NFTaskManager sharedManager].resultCategoryArray addObjectsFromArray: [self sortArray:[NFFirebaseManager sharedManager].resultCategoryArray withKey:@"resultCategoryIndex"]];
    
    [[NFTaskManager sharedManager].resultsArray removeAllObjects];
    [[NFTaskManager sharedManager].resultsArray  addObjectsFromArray:[NFFirebaseManager sharedManager].resultsArray];
    
    //[[NFTaskManager sharedManager].valuesArray addObjectsFromArray:[self sortArray:self.valuesArray withKey:@"valueIndex"]];
    [[NFTaskManager sharedManager].valuesArray addObjectsFromArray: [self sincUserValues:self.valuesArray withBaseValues:[NFFirebaseManager sharedManager].baseValuesArray]];
    
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
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
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
/*
 NSSortDescriptor *sortDescriptor;
 sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryID"
 ascending:YES];
 NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
 self.carCategories = (NSMutableArray*)[thisData sortedArrayUsingDescriptors:sortDescriptors];
 */

@end
