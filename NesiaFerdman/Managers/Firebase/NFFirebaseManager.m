//
//  NFFirebaseManager.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 4/24/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFFirebaseManager.h"
#import "NFGoogleManager.h"
#import "NFResultCategory.h"
#import "NFManifestation.h"
#import "NFSettingManager.h"

@import FirebaseAuth;

@interface NFFirebaseManager()
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) FIRRemoteConfig *remoteConfig;

@property (assign, nonatomic) BOOL isValueLoaded;
@property (assign, nonatomic) BOOL isBaseValueLoaded;
@property (assign, nonatomic) BOOL isEventLoaded;
@property (assign, nonatomic) BOOL isResultCategoryLoaded;
@property (assign, nonatomic) BOOL isResultLoaded;
@property (assign, nonatomic) BOOL isManifestationsLoaded;

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
        self.baseValuesArray = [NSMutableArray array];
        self.resultCategoryArray = [NSMutableArray array];
        self.resultsArray = [NSMutableArray array];
        self.manifestationsArray = [NSMutableArray array];
            }
    return self;
}

- (void)writeEventToFirebase:(NFEvent *)event withUserId:(NSString *)userId {
    NSMutableDictionary *eventlDictionary = [NSMutableDictionary dictionary];
    if (event.values.count > 0) {
        NSMutableArray *tempValues = [NSMutableArray array];
        for (id val in event.values) {
            if ([val isKindOfClass:[NFValue class]]) {
                [tempValues addObject:[val convertToDictionary]];
            } else if ([val isKindOfClass:[NSMutableDictionary class]]) {
                [tempValues addObject:val];
            } else {
                NSLog(@"error convert value");
            }
        }
        [event.values removeAllObjects];
        [event.values addObjectsFromArray:tempValues];
    }
    eventlDictionary = (NSMutableDictionary*)[event convertToDictionary];
    [[[[[self.ref child:@"Users"] child:userId] child:@"Events"]child:event.eventId] updateChildValues:eventlDictionary
                                                                                   withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref)
    {
        if (error) {
            NSLog(@"error write to firebase %@", error);
        }
    }];
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
             //if (!event.isDeleted) {
                 [eventsArray addObject:event];
          //   } else {
           //  }
         }
         
         [self getAllValues];
         [self getAllBaseValues];
         [self getAllResultCategory];
         [self getAllManifestations];
         [self getAllResultsWithUserId:[[NFGoogleManager sharedManager] getUserId]];
         
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
         }
         [self.valuesArray removeAllObjects];
         [self.valuesArray addObjectsFromArray:valuesArray];
         _isValueLoaded = YES;
         [self compliteLoading];
     }];
}

- (void)getAllBaseValues {
    
    [[self.ref child:@"Values"]
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
         [self.baseValuesArray removeAllObjects];
         [self.baseValuesArray addObjectsFromArray:valuesArray];
         _isBaseValueLoaded = YES;
         [self compliteLoading];
     }];

    
}

- (void)getAllResultsWithUserId:(NSString*)userId {
    [[[[self.ref child:@"Users"] child:userId] child:@"Results"]
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
             NFResult *val = [[NFResult alloc] initWithDictionary:dic];
             [valuesArray addObject:val];
             //NSLog(@"value name %@", val.valueTitle);
         }
         [self.resultsArray removeAllObjects];
         [self.resultsArray addObjectsFromArray:valuesArray];
         _isResultLoaded = YES;
         [self compliteLoading];
     }];
}

- (void)getAllResultCategory {
   [[self.ref child:@"ResultCategory"]
     observeEventType:FIRDataEventTypeValue
     withBlock:^(FIRDataSnapshot *snapshot) {
         NSMutableArray *valuesArray = [NSMutableArray array];
         
         // Loop over children
         NSMutableArray *dataArray = [NSMutableArray array];
         NSEnumerator *children = [snapshot children];
         FIRDataSnapshot *child;
         while (child = [children nextObject]) {
             NSDictionary *value = [NSDictionary dictionaryWithDictionary:(NSDictionary*)child.value];
             [dataArray addObject:value];
             //NSLog(@"events form firebase->>> %@", event);
         }
         for (NSDictionary *dic in dataArray) {
             NFResultCategory *val = [[NFResultCategory alloc] initWithDictionary:dic];
             [valuesArray addObject:val];
         }
         [self.resultCategoryArray removeAllObjects];
         [self.resultCategoryArray addObjectsFromArray:valuesArray];
         _isResultCategoryLoaded = YES;
         [self compliteLoading];
     }];
}

- (void)getAllManifestations {
    [[self.ref child:@"Manifestations"]
     observeEventType:FIRDataEventTypeValue
     withBlock:^(FIRDataSnapshot *snapshot) {
         NSMutableArray* resultArray = [NSMutableArray new];
         
         // Loop over children
         NSMutableArray *dataArray = [NSMutableArray array];
         NSEnumerator *children = [snapshot children];
         FIRDataSnapshot *child;
         while (child = [children nextObject]) {
             NSDictionary *value = [NSDictionary dictionaryWithDictionary:(NSDictionary*)child.value];
             [dataArray addObject:value];
             NSLog(@"Manifestations");
         }
         for (NSDictionary *dic in dataArray) {
             NSMutableArray *tempArray = [NSMutableArray new];
             NSMutableArray *list = [NSMutableArray new];
             [tempArray addObjectsFromArray:[dic allValues]];
             for (NSDictionary *dicM in tempArray) {
                 NFManifestation *item = [[NFManifestation alloc] initWithDictionary:dicM];
                 [list addObject:item];
             }
             if (list.count > 0) {
                 [resultArray addObject:list];
             }
         }
         [self.manifestationsArray removeAllObjects];
         [self.manifestationsArray addObjectsFromArray:resultArray];
         _isManifestationsLoaded = YES;
         [self compliteLoading];
     }];
}

- (void)addValue:(NFValue *)value withUserId:(NSString *)userId {
    [[[[[self.ref child:@"Users"] child:userId] child:@"Values"] child:value.valueId] updateChildValues:[value convertToDictionary]];
}

- (void)addResult:(NFResult*)result withUserId:(NSString *)userId {
    [[[[[self.ref child:@"Users"] child:userId] child:@"Results"] child:result.resultId] updateChildValues:[result convertToDictionary]];
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

- (void)getMinSyncInterval  {
    [[[_ref child:@"SyncTimeInterval"] child:@"Min"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSNumber *interval = snapshot.value;
        if (interval) {
            [NFSettingManager setMinIntervalOfSync:interval];
            NSLog(@"min %@", interval);
        }
    }];
}

- (void)getMaxSyncInterval {
    [[[_ref child:@"SyncTimeInterval"] child:@"Max"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSNumber *interval = snapshot.value;
        if (interval) {
            [NFSettingManager setMaxIntervalOfSync:interval];
            NSLog(@"max %@", interval);
        }
    }];

}

// standart data Admin part

- (void)setMinSyncPeriodDays:(NSNumber*)min andMaxPeriodDays:(NSNumber*)max {
    
    [[[self.ref child:@"SyncTimeInterval"]  child:@"Min"] setValue:min];
    [[[self.ref child:@"SyncTimeInterval"]  child:@"Max"] setValue:max];

}

- (void)addResultCategory:(NFResultCategory *)category {
    [[[self.ref child:@"ResultCategory"]  child:category.resultCategoryId] updateChildValues:[category convertToDictionary]];
}

- (void)addManifestation:(NFManifestation*)manifestation {
    [[[[self.ref child:@"Manifestations"]  child:manifestation.categoryKey] child:manifestation.manifestationId] updateChildValues:[manifestation convertToDictionary]];
}

- (void)addManifestation:(NFManifestation*)manifestation toValue:(NFValue*)value userId:(NSString*)userId {
    [[[[[[[self.ref child:@"Users"] child:userId]
         child:@"Values"]
        child:value.valueId]
       child:@"manifestations"]
      child:manifestation.manifestationId]
     updateChildValues:[manifestation convertToDictionary]];
}

- (NSMutableArray*)getAllManifestationsForValue:(NFValue*)value userId:(NSString*)userId {
    NSMutableArray* resultArray = [NSMutableArray new];

    [[[[[[self.ref child:@"Users"] child:userId]
        child:@"Values"]
       child:value.valueId]
      child:@"manifestations"]
     observeEventType:FIRDataEventTypeValue
     withBlock:^(FIRDataSnapshot *snapshot) {
         
         // Loop over children
         NSMutableArray *dataArray = [NSMutableArray array];
         NSEnumerator *children = [snapshot children];
         FIRDataSnapshot *child;
         while (child = [children nextObject]) {
             NSDictionary *value = [NSDictionary dictionaryWithDictionary:(NSDictionary*)child.value];
             [dataArray addObject:[value allValues]];
             NSLog(@"Manifestations");
         }
         for (NSDictionary *dic in dataArray) {
             NSMutableArray *tempArray = [NSMutableArray new];
             NSMutableArray *list = [NSMutableArray new];
             [tempArray addObjectsFromArray:[dic allValues]];
             for (NSDictionary *dicM in tempArray) {
                 NFManifestation *item = [[NFManifestation alloc] initWithDictionary:dicM];
                 [list addObject:item];
             }
             if (list.count > 0) {
                 [resultArray addObject:list];
             }
         }
        }];
    return resultArray;
}

- (void)addStandartValue:(NFValue *)value withUserId:(NSString *)userId {
    [[[self.ref child:@"Values"]  child:value.valueId] updateChildValues:[value convertToDictionary]];
}

- (void)addSatndartListOfManifestations {
    NSString *kJob = @"Job";
    NSString *kRelations = @"Relations";
    NSString *kFamilyAndFriends = @"FamilyAndFriends";
    NSString *kLife = @"Life";
    NSString *kBodyAndHealth = @"BodyAndHealth";
    NSString *kEvolution = @"Evolution";
    NSString *kMaterialProsperity = @"MaterialProsperity";
    NSString *kRelaxation = @"Relaxation";
    
    NSString *kJobTitle = @"Работа";
    NSString *kRelationsTitle = @"Отношения";
    NSString *kFamilyAndFriendsTitle = @"Семья и друзья";
    NSString *kLifeTitle = @"Быт";
    NSString *kBodyAndHealthTitle = @"Тело и здоровье";
    NSString *kEvolutionTitle = @"Развитие";
    NSString *kMaterialProsperityTitle = @"Материальное благополучие";
    NSString *kRelaxationTitle = @"Отдых";

    
    
    NSArray *categorysTitle = [NSArray arrayWithObjects:kJobTitle, kRelationsTitle, kFamilyAndFriendsTitle,
                               kLifeTitle, kBodyAndHealthTitle, kEvolutionTitle, kMaterialProsperityTitle, kRelaxationTitle,  nil];
    NSArray *keyArray = [NSArray arrayWithObjects:kJob,kRelations, kFamilyAndFriends, kLife, kBodyAndHealth, kEvolution, kMaterialProsperity, kRelaxation,  nil];
    NSArray *manifestationsTitle = [NSArray arrayWithObjects:@"Что для меня важно в этой сфере?",
                                    @"Что для меня на самом деле имеет значение?",
                                    @"Чего я хочу?",
                                    @"Без чего я чувствую себя неудовлетворенным в этой сфере?", nil];
    
    for (NSString* key in keyArray) {
        int index = 0;
        
        for (NSString *title in manifestationsTitle) {
            NFManifestation *manifestation = [NFManifestation new];
            manifestation.categoryKey = key;
            manifestation.categoryTitle = [categorysTitle objectAtIndex:[keyArray indexOfObject:key]];
            manifestation.index = [NSNumber numberWithInt:index];
            manifestation.name = title;
            [self addManifestation:manifestation];
            index++;
        }
    }
}

- (void)addStandartListOfValuesToDateBaseWithUserId:(NSString *)userId {
    
    NFValue *job = [NFValue new];
    job.valueId = @"0703F55D-0CAE-495C-8202-job";
    job.valueTitle = @"Работа";
    job.valueIndex = @0;
    job.valueImage = @"job_value_icon.png";
    
    [self addStandartValue:job withUserId:userId];
    //
    NFValue *relations = [NFValue new];
    relations.valueId = @"0703F55D-0CAE-495C-8202-relations";
    relations.valueTitle = @"Отношения";
    relations.valueIndex = @1;
    relations.valueImage = @"relations_value_icon.png";
    
    [self addStandartValue:relations withUserId:userId];
    //
    NFValue *familyAndFriends = [NFValue new];
    familyAndFriends.valueId = @"0703F55D-0CAE-495C-8202-familyAndFriends";
    familyAndFriends.valueTitle = @"Семья и друзья";
    familyAndFriends.valueIndex = @2;
    familyAndFriends.valueImage = @"famely_value_icon.png";
    [self addStandartValue:familyAndFriends withUserId:userId];
    
    NFValue *life = [NFValue new];
    life.valueId = @"0703F55D-0CAE-495C-8202-life";
    life.valueTitle = @"Быт";
    life.valueIndex = @3;
    life.valueImage = @"Home_life_value_icon.png";
    [self addStandartValue:life withUserId:userId];
    
    NFValue *bodyAndHealth = [NFValue new];
    bodyAndHealth.valueId = @"0703F55D-0CAE-495C-8202-bodyAndHealth";
    bodyAndHealth.valueTitle = @"Тело и здоровье";
    bodyAndHealth.valueIndex = @4;
    bodyAndHealth.valueImage = @"heart_value_icon.png";
    [self addStandartValue:bodyAndHealth withUserId:userId];
    
    NFValue *evolution = [NFValue new];
    evolution.valueId = @"0703F55D-0CAE-495C-8202-evolution";
    evolution.valueTitle = @"Развитие";
    evolution.valueIndex = @5;
    evolution.valueImage = @"upgrate_value_icon.png";
    [self addStandartValue:evolution withUserId:userId];
    
    NFValue *materialProsperity = [NFValue new];
    materialProsperity.valueId = @"0703F55D-0CAE-495C-8202-materialProsperity";
    materialProsperity.valueTitle = @"Материальное благополучие";
    materialProsperity.valueIndex = @6;
    materialProsperity.valueImage = @"money_value_icon.png";
    [self addStandartValue:materialProsperity withUserId:userId];
    
    NFValue *relaxation = [NFValue new];
    relaxation.valueId =@"0703F55D-0CAE-495C-8202-relaxation";
    relaxation.valueTitle = @"Отдых";
    relaxation.valueIndex = @7;
    relaxation.valueImage = @"relax_value_icon.png";
    [self addStandartValue:relaxation withUserId:userId];
}

- (void) addStandartListOfResultCategoryToDateBase {
    NFResultCategory *achievements = [NFResultCategory new];
    achievements.resultCategoryTitle = @"Достижения";
    achievements.resultCategoryId = @"0703F55D-0CAE-495C-8202-achievements";
    achievements.resultCategoryIndex = @0;
    [self addResultCategory:achievements];
    //
    NFResultCategory *discoveries = [NFResultCategory new];
    discoveries.resultCategoryTitle = @"Открытия";
    discoveries.resultCategoryId = @"0703F55D-0CAE-495C-8202-discoveries";
    discoveries.resultCategoryIndex = @1;
    [self addResultCategory:discoveries];

    //
    NFResultCategory *people = [NFResultCategory new];
    people.resultCategoryTitle = @"Люди";
    people.resultCategoryId = @"0703F55D-0CAE-495C-8202-people";
    people.resultCategoryIndex = @2;
    [self addResultCategory:people];

    //
    NFResultCategory *quotesOrThoughts = [NFResultCategory new];
    quotesOrThoughts.resultCategoryTitle = @"Цитаты или мысли";
    quotesOrThoughts.resultCategoryId = @"0703F55D-0CAE-495C-8202-quotesOrThoughts";
    quotesOrThoughts.resultCategoryIndex = @3;
    [self addResultCategory:quotesOrThoughts];

    //
    NFResultCategory *growthArea = [NFResultCategory new];
    growthArea.resultCategoryTitle = @"Зона роста";
    growthArea.resultCategoryId = @"0703F55D-0CAE-495C-8202-growthArea";
    growthArea.resultCategoryIndex = @4;
    [self addResultCategory:growthArea];

    //
    NFResultCategory *pleased = [NFResultCategory new];
    pleased.resultCategoryTitle = @"Порадовало";
    pleased.resultCategoryId = @"0703F55D-0CAE-495C-8202-pleased";
    pleased.resultCategoryIndex = @5;
    [self addResultCategory:pleased];

    //
    NFResultCategory *interesting = [NFResultCategory new];
    interesting.resultCategoryTitle = @"Интересное";
    interesting.resultCategoryId = @"0703F55D-0CAE-495C-8202-interesting";
    interesting.resultCategoryIndex = @6;
    [self addResultCategory:interesting];

    //
    NFResultCategory *thankfulness = [NFResultCategory new];
    thankfulness.resultCategoryTitle = @"Благодарность";
    thankfulness.resultCategoryId = @"0703F55D-0CAE-495C-8202-thankfulness";
    thankfulness.resultCategoryIndex = @7;
    [self addResultCategory:thankfulness];

}

- (void)compliteLoading {
    if (_isValueLoaded && _isEventLoaded && _isResultCategoryLoaded && _isResultLoaded && _isBaseValueLoaded && _isManifestationsLoaded) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSNotification *notification = [NSNotification notificationWithName:FIREBASE_NOTIF object:self];
            [[NSNotificationCenter defaultCenter]postNotification:notification];
            _isValueLoaded = NO;
            _isEventLoaded = NO;
            _isResultCategoryLoaded = NO;
            _isResultLoaded = NO;
            _isBaseValueLoaded = NO;
            _isManifestationsLoaded = NO;
        });
    }
}


- (void)clearData {
    [self.firebaseEventsArray removeAllObjects];
    [self.valuesArray removeAllObjects];
}


@end
