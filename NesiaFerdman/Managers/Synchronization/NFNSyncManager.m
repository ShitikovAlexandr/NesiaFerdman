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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotyficatin) name:NOTIFYCATIN_CALENDAR_LIST_LOAD object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotyficatin) name:NOTIFYCATIN_EVENT_LOAD object:nil];
    }
    return self;
}

- (void)loadDataFromDataBase {
    NSLog(@"get data from firebase");
    [[NFFirebaseSyncManager sharedManager] loadAllData];
}

- (void)loadDataFromGoogle {
    [[NFGoogleSyncManager sharedManager] loadGoogleCalendarList];
}

- (void)updateData {
    [self loadDataFromDataBase];
    [self loadDataFromGoogle];
}

#pragma mark - data base methods

- (void)writeEventToDataBase:(NFNEvent*)event {
    [[NFFirebaseSyncManager sharedManager] writeEvent:event];
}

- (void)writeCalendarToDataBase:(NFGoogleCalendar*)calendar {
    [[NFFirebaseSyncManager sharedManager] writeCalendar:calendar];
}

- (void)getNotyficatin {
    
}


@end
