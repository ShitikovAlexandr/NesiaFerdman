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
        //Googlle
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endDownloadData)name:NOTIFYCATIN_CALENDAR_LIST_LOAD object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endDownloadData)name:NOTIFYCATIN_EVENT_LOAD object:nil];
        //firebase
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endDownloadData)name:DATA_BASE_COMPLITE_DOWNLOADED_ALL_DATA object:nil];
    }
    return self;
}

- (void)loadDataFromDataBase {
    NSLog(@"get data from firebase");
    [[NFFirebaseSyncManager sharedManager] downloadAllData];
}

- (void)loadDataFromGoogle {
    [[NFGoogleSyncManager sharedManager] loadGoogleCalendarList];
    
}

- (void)updateData {
    [self loadDataFromDataBase];
    [self loadDataFromGoogle];
}


#pragma mark - sync methods

- (void)googleCalendarListIsDownloaded {
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


- (void)endDownloadData {
    NSLog(@"endDownloadData");
}


@end
