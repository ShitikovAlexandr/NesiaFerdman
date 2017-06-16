//
//  NFFirebaseManager.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 4/24/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NFEvent.h"
#import "NotifyList.h"
#import "NFValue.h"
@import Firebase;



@interface NFFirebaseManager : NSObject
@property (strong, nonatomic) NSMutableArray *firebaseEventsArray;
@property (strong, nonatomic) NSMutableArray *valuesArray;

+ (NFFirebaseManager *)sharedManager;

- (void)getAccessToFirebase;

- (void)writeEventToFirebase:(NFEvent *)event withUserId:(NSString *)userId;
- (void)deleteEventFromFirebase:(NFEvent *)event withUserId:(NSString *)userId;
- (void)getDataFromFirebase;

- (void)getAllValues;
- (void)deleteValue:(NFValue *)value withUserId:(NSString *)userId;
- (void)addValue:(NFValue *)value withUserId:(NSString *)userId;

- (void)addStandartListOfValuesToDateBaseWithUserId:(NSString *)userId;

//

- (void)registratinOfNewUserWithEmail:(NSString*)email password:(NSString*)password;
- (void)sinInWithEmail:(NSString*)email password:(NSString*)password;
- (void)singOutFromFirebase;

- (void)clearData;


@end
