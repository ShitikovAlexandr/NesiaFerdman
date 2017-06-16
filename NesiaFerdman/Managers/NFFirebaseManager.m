//
//  NFFirebaseManager.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 4/24/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFFirebaseManager.h"
#import "NFGoogleManager.h"
@import FirebaseAuth;

@interface NFFirebaseManager()
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) FIRRemoteConfig *remoteConfig;

@property (assign, nonatomic) BOOL isValueLoaded;
@property (assign, nonatomic) BOOL isEventLoaded;

@end

@implementation NFFirebaseManager

+ (NFFirebaseManager *)sharedManager {
    static NFFirebaseManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.ref = [[FIRDatabase database] reference];
        self.firebaseEventsArray = [NSMutableArray array];
        self.valuesArray = [NSMutableArray array];
            }
    return self;
}

- (void)writeEventToFirebase:(NFEvent *)event withUserId:(NSString *)userId {
    NSMutableDictionary *eventlDictionary = [NSMutableDictionary dictionary];
    if (event.values.count > 0) {
        NSMutableArray *tempValues = [NSMutableArray array];
        for (NFValue *val in event.values) {
            [tempValues addObject:[val convertToDictionary]];
        }
        [event.values removeAllObjects];
        [event.values addObjectsFromArray:tempValues];
    }
    eventlDictionary = (NSMutableDictionary*)[event convertToDictionary];
    NSLog(@"event to firebase %@", eventlDictionary);
    [[[[[self.ref child:@"Users"] child:userId] child:@"Events"]child:event.eventId] updateChildValues:eventlDictionary];
}

- (void)deleteEventFromFirebase:(NFEvent *)event withUserId:(NSString *)userId {
    [[[[[self.ref child:@"Users"] child:userId] child:@"Events"]child:event.eventId] removeValue];
}

- (void)getAccessToFirebase {
    [[FIRAuth auth]
     signInAnonymouslyWithCompletion:^(FIRUser *_Nullable user, NSError *_Nullable error) {
         self.remoteConfig = [FIRRemoteConfig remoteConfig];
     }];
}


- (void)getDataFromFirebase {
    
    [[[[self.ref child:@"Users"] child:[[NFGoogleManager sharedManager] getUserId]] child:@"Events"]
     observeEventType:FIRDataEventTypeValue
     withBlock:^(FIRDataSnapshot *snapshot) {
         NSMutableArray *eventsArray = [NSMutableArray array];

         // Loop over children
         NSMutableArray *dataArray = [NSMutableArray array];
         NSEnumerator *children = [snapshot children];
         //NSLog(@"children %@", children);
         FIRDataSnapshot *child;
         while (child = [children nextObject]) {
             NSDictionary *event = [NSDictionary dictionaryWithDictionary:(NSDictionary*)child.value];
             [dataArray addObject:event];
             //NSLog(@"events form firebase->>> %@", event);
         }
         for (NSDictionary *dic in dataArray) {
             NFEvent *event = [[NFEvent alloc] initWithDictionary:dic];
             [eventsArray addObject:event];
         }
         
         [self getAllValues];
         
         [self.firebaseEventsArray removeAllObjects];
         [self.firebaseEventsArray addObjectsFromArray:eventsArray];
         _isEventLoaded = YES;
//         NSNotification *notification = [NSNotification notificationWithName:FIREBASE_NOTIF object:self];
//         [[NSNotificationCenter defaultCenter]postNotification:notification];
         [self compliteLoading];
     }];
}

#pragma mark - Values

- (void)getAllValues {
    [[[[self.ref child:@"Users"] child:[[NFGoogleManager sharedManager] getUserId]] child:@"Values"]
     observeEventType:FIRDataEventTypeValue
     withBlock:^(FIRDataSnapshot *snapshot) {
         NSMutableArray *valuesArray = [NSMutableArray array];
         
         // Loop over children
         NSMutableArray *dataArray = [NSMutableArray array];
         NSEnumerator *children = [snapshot children];
         //NSLog(@"children %@", children);
         FIRDataSnapshot *child;
         while (child = [children nextObject]) {
             NSDictionary *value = [NSDictionary dictionaryWithDictionary:(NSDictionary*)child.value];
             [dataArray addObject:value];
             //NSLog(@"events form firebase->>> %@", event);
         }
         for (NSDictionary *dic in dataArray) {
             NFValue *val = [[NFValue alloc] initWithDictionary:dic];
             [valuesArray addObject:val];
             NSLog(@"value name %@", val.valueTitle);
         }
         [self.valuesArray removeAllObjects];
         [self.valuesArray addObjectsFromArray:valuesArray];
         _isValueLoaded = YES;
         [self compliteLoading];
        

     }];
}


- (void)addValue:(NFValue *)value withUserId:(NSString *)userId {
    [[[[[self.ref child:@"Users"] child:userId] child:@"Values"] child:value.valueId] updateChildValues:[value convertToDictionary]];
}

- (void)deleteValue:(NFValue *)value withUserId:(NSString *)userId {
     [[[[[self.ref child:@"Users"] child:userId] child:@"Values"] child:value.valueId] removeValue];
}

- (void)registratinOfNewUserWithEmail:(NSString*)email password:(NSString*)password {
    [[FIRAuth auth] createUserWithEmail:email
                               password:password
                             completion:^(FIRUser *_Nullable user, NSError *_Nullable error) {
                                 if (user) {
                                     NSLog(@"new user is registered %@", user);
                                 } else {
                                     NSLog(@"error register new user %@", error);
                                 }
                             }];
}

- (void)sinInWithEmail:(NSString*)email password:(NSString*)password {
    [[FIRAuth auth] signInWithEmail:email
                           password:password
                         completion:^(FIRUser *user, NSError *error) {
                             if (user) {
                                 NSLog(@"new user is registered %@", user);
                             } else {
                                 NSLog(@"error register new user %@", error);
                             }
                         }];
}

- (void)singOutFromFirebase {
    NSError *signOutError;
    BOOL status = [[FIRAuth auth] signOut:&signOutError];
    if (!status) {
        NSLog(@"Error signing out: %@", signOutError);
        return;
    }
}

- (void)addStandartListOfValuesToDateBaseWithUserId:(NSString *)userId {
    
    NFValue *job = [NFValue new];
    job.valueId = @"0703F55D-0CAE-495C-8202-job";
    job.valueTitle = @"Работа";
    job.valueIndex = @0;
    job.valueImage = @"job_value_icon.png";
    [self addValue:job withUserId:userId];
    
    NFValue *relations = [NFValue new];
    relations.valueId = @"0703F55D-0CAE-495C-8202-relations";
    relations.valueTitle = @"Отношения";
    relations.valueIndex = @1;
    relations.valueImage = @"relations_value_icon.png";
    [self addValue:relations withUserId:userId];
    
    NFValue *familyAndFriends = [NFValue new];
    familyAndFriends.valueId = @"0703F55D-0CAE-495C-8202-familyAndFriends";
    familyAndFriends.valueTitle = @"Семья и друзья";
    familyAndFriends.valueIndex = @2;
    familyAndFriends.valueImage = @"famely_value_icon.png";
    [self addValue:familyAndFriends withUserId:userId];
    
    NFValue *life = [NFValue new];
    life.valueId = @"0703F55D-0CAE-495C-8202-life";
    life.valueTitle = @"Быт";
    life.valueIndex = @3;
    life.valueImage = @"Home_life_value_icon.png";
    [self addValue:life withUserId:userId];
    
    NFValue *bodyAndHealth = [NFValue new];
    bodyAndHealth.valueId = @"0703F55D-0CAE-495C-8202-bodyAndHealth";
    bodyAndHealth.valueTitle = @"Тело и здоровье";
    bodyAndHealth.valueIndex = @4;
    bodyAndHealth.valueImage = @"heart_value_icon.png";
    [self addValue:bodyAndHealth withUserId:userId];
    
    NFValue *evolution = [NFValue new];
    evolution.valueId = @"0703F55D-0CAE-495C-8202-evolution";
    evolution.valueTitle = @"Развитие";
    evolution.valueIndex = @5;
    evolution.valueImage = @"upgrate_value_icon.png";
    [self addValue:evolution withUserId:userId];
    
    NFValue *materialProsperity = [NFValue new];
    materialProsperity.valueId = @"0703F55D-0CAE-495C-8202-materialProsperity";
    materialProsperity.valueTitle = @"Материальное благополучие";
    materialProsperity.valueIndex = @6;
    materialProsperity.valueImage = @"money_value_icon.png";
    [self addValue:materialProsperity withUserId:userId];
    
    NFValue *relaxation = [NFValue new];
    relaxation.valueId =@"0703F55D-0CAE-495C-8202-relaxation";
    relaxation.valueTitle = @"Отдых";
    relaxation.valueIndex = @7;
    relaxation.valueImage = @"relax_value_icon.png";
    [self addValue:relaxation withUserId:userId];
}

- (void)compliteLoading {
    if (_isValueLoaded && _isEventLoaded) {
        NSNotification *notification = [NSNotification notificationWithName:FIREBASE_NOTIF object:self];
        [[NSNotificationCenter defaultCenter]postNotification:notification];
        _isValueLoaded = NO;
        _isEventLoaded = NO;
    }
}

- (void)clearData {
    [self.firebaseEventsArray removeAllObjects];
    [self.valuesArray removeAllObjects];
}


@end
