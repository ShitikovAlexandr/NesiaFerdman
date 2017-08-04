//
//  NFAdminManager.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 7/24/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFAdminManager.h"
#import "NFFirebaseSyncManager.h"

@implementation NFAdminManager




+ (void)writeAppStandartListOfValueToDataBase {
    for (NFNValue *val in [self standartListOfValues]) {
        [[NFFirebaseSyncManager sharedManager] writAppValueToDataBase:val];
    }
    
}

+ (void)writeAppStandartListOfResultCategoryToDataBase {
    for (NFNRsultCategory *category in [self standartListOfResultCategory]) {
        [[NFFirebaseSyncManager sharedManager] writeAppResultCategoryToDataBase:category];
    }
}

+ (void)writeStandartManifestationsToDataBase {
    for (NFNValue* val in [self standartListOfValues]) {
        for (NFNManifestation* manif in [self satndartListOfManifestations]) {
            [[NFFirebaseSyncManager sharedManager] writeAppManifestation:manif toValue:val];
        }
    }
}



+ (void)writeQuote {
    for (int i = 0; i < 31; i++) {
        NFNQuote *quote = [[NFNQuote alloc] init];
        quote.index = 0;
        quote.date = @"2017-08-04";
        quote.author = [NSString stringWithFormat:@"test author #%d", i];
        quote.title = [NSString stringWithFormat:@"test quote #%d", i];
        [[NFFirebaseSyncManager sharedManager] writeQuoteToDataBase:quote];
    }
}

+ (void)writeOption {
    [[NFFirebaseSyncManager sharedManager] writeMaxTime:@120];
    [[NFFirebaseSyncManager sharedManager] writeMinTime:@120];
   // [[NFFirebaseSyncManager sharedManager] writeMaxLimitGoogle:@1000];
}

+ (NSMutableArray*)satndartListOfManifestations {
    NSMutableArray *resultArray = [NSMutableArray array];
    
    NSArray *manifestationsTitle = [NSArray arrayWithObjects:@"Что для меня важно в этой сфере?",
                                    @"Что для меня на самом деле имеет значение?",
                                    @"Чего я хочу?",
                                    @"Без чего я чувствую себя неудовлетворенным в этой сфере?", nil];
    
    int index = 0;
    for (NSString *title in manifestationsTitle) {
        NFNManifestation *manifestation = [NFNManifestation new];
        manifestation.title = title;
        manifestation.index = index;
        [resultArray addObject:manifestation];
        index++;
    }
    return resultArray;
}


+ (NSMutableArray*)standartListOfResultCategory {
    NSMutableArray *resultArray = [NSMutableArray new];
    
    NFNRsultCategory *achievements = [NFNRsultCategory new];
    achievements.title = @"Достижения";
    achievements.idField = @"0703F55D-0CAE-495C-8202-achievements";
    achievements.index = 0;
    [resultArray addObject:achievements];
    
    NFNRsultCategory *discoveries = [NFNRsultCategory new];
    discoveries.title = @"Открытия";
    discoveries.idField = @"0703F55D-0CAE-495C-8202-discoveries";
    discoveries.index = 1;
    [resultArray addObject:discoveries];
    
    NFNRsultCategory *people = [NFNRsultCategory new];
    people.title = @"Люди";
    people.idField = @"0703F55D-0CAE-495C-8202-people";
    people.index = 2;
    [resultArray addObject:people];
    
    NFNRsultCategory *quotesOrThoughts = [NFNRsultCategory new];
    quotesOrThoughts.title = @"Цитаты или мысли";
    quotesOrThoughts.idField = @"0703F55D-0CAE-495C-8202-quotesOrThoughts";
    quotesOrThoughts.index = 3;
    [resultArray addObject:quotesOrThoughts];
    
    NFNRsultCategory *growthArea = [NFNRsultCategory new];
    growthArea.title = @"Зона роста";
    growthArea.idField = @"0703F55D-0CAE-495C-8202-growthArea";
    growthArea.index = 4;
    [resultArray addObject:growthArea];
    NFNRsultCategory *pleased = [NFNRsultCategory new];
    pleased.title = @"Порадовало";
    pleased.idField = @"0703F55D-0CAE-495C-8202-pleased";
    pleased.index = 5;
    [resultArray addObject:pleased];
    
    NFNRsultCategory *interesting = [NFNRsultCategory new];
    interesting.title = @"Интересное";
    interesting.idField = @"0703F55D-0CAE-495C-8202-interesting";
    interesting.index = 6;
    [resultArray addObject:interesting];
    
    NFNRsultCategory *thankfulness = [NFNRsultCategory new];
    thankfulness.title = @"Благодарность";
    thankfulness.idField = @"0703F55D-0CAE-495C-8202-thankfulness";
    thankfulness.index = 7;
    [resultArray addObject:thankfulness];
    return resultArray;
}



+ (NSMutableArray*)standartListOfValues {
    
    NSMutableArray *resultArray = [NSMutableArray array];
    
    
    NFNValue *job = [NFNValue new];
    job.valueId = @"0703F55D-0CAE-495C-8202-job";
    job.valueTitle = @"Работа";
    job.valueIndex = 0;
    job.valueImage = @"job_value_icon.png";
    [resultArray addObject:job];
    
    NFNValue *relations = [NFNValue new];
    relations.valueId = @"0703F55D-0CAE-495C-8202-relations";
    relations.valueTitle = @"Отношения";
    relations.valueIndex = 1;
    relations.valueImage = @"relations_value_icon.png";
    [resultArray addObject:relations];
    
    NFNValue *familyAndFriends = [NFNValue new];
    familyAndFriends.valueId = @"0703F55D-0CAE-495C-8202-familyAndFriends";
    familyAndFriends.valueTitle = @"Семья и друзья";
    familyAndFriends.valueIndex = 2;
    familyAndFriends.valueImage = @"famely_value_icon.png";
    [resultArray addObject:familyAndFriends];
    
    NFNValue *life = [NFNValue new];
    life.valueId = @"0703F55D-0CAE-495C-8202-life";
    life.valueTitle = @"Быт";
    life.valueIndex = 3;
    life.valueImage = @"Home_life_value_icon.png";
    [resultArray addObject:life];
    
    NFNValue *bodyAndHealth = [NFNValue new];
    bodyAndHealth.valueId = @"0703F55D-0CAE-495C-8202-bodyAndHealth";
    bodyAndHealth.valueTitle = @"Тело и здоровье";
    bodyAndHealth.valueIndex = 4;
    bodyAndHealth.valueImage = @"heart_value_icon.png";
    [resultArray addObject:bodyAndHealth];
    
    NFNValue *evolution = [NFNValue new];
    evolution.valueId = @"0703F55D-0CAE-495C-8202-evolution";
    evolution.valueTitle = @"Развитие";
    evolution.valueIndex = 5;
    evolution.valueImage = @"upgrate_value_icon.png";
    [resultArray addObject:evolution];
    
    NFNValue *materialProsperity = [NFNValue new];
    materialProsperity.valueId = @"0703F55D-0CAE-495C-8202-materialProsperity";
    materialProsperity.valueTitle = @"Материальное благополучие";
    materialProsperity.valueIndex = 6;
    materialProsperity.valueImage = @"money_value_icon.png";
    [resultArray addObject:materialProsperity];
    
    NFNValue *relaxation = [NFNValue new];
    relaxation.valueId =@"0703F55D-0CAE-495C-8202-relaxation";
    relaxation.valueTitle = @"Отдых";
    relaxation.valueIndex = 7;
    relaxation.valueImage = @"relax_value_icon.png";
    [resultArray addObject:relaxation];
    
    return resultArray;
}


@end
