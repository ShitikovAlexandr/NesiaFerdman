//
//  NFResultInfoDataSource.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 10/2/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFResultInfoDataSource.h"
#import "NFResultInfoItem.h"

@implementation NFResultInfoDataSource

- (NSArray*)getData {
    NSMutableArray* dataArray = [NSMutableArray new];
    
//    NFResultInfoItem *item1 = [[NFResultInfoItem alloc] init];
//    item1.title = @"Итог:";
//    item1.isBold = true;
//    [dataArray addObject:item1];
    
    NFResultInfoItem *item2 = [[NFResultInfoItem alloc] init];
    item2.title = @"В конце каждой недели вы сможете подвести итог своих действий и проявления ваших ценностей. Важно, чтобы возле каждого действия была указана та ценность, которую проявляет это действие. Это поможет вам работать над проявлением этой ценности.";
    item2.isBold = false;
    [dataArray addObject:item2];
    
    NFResultInfoItem *item3 = [[NFResultInfoItem alloc] init];
    item3.title = @"У вас есть возможность в течение  недели/месяца записывать и просматривать, когда вам удобно ваши:";
    item3.isBold = false;
    [dataArray addObject:item3];
    
    //list
//    NFResultInfoItem *item4 = [[NFResultInfoItem alloc] init];
//    item4.title = @"Достижения (Что удалось и чем гордишься?)";
//    item4.isBold = false;
//    item4.inList = true;
//    [dataArray addObject:item4];
    
    NFResultInfoItem *item5 = [[NFResultInfoItem alloc] init];
    item5.title = @"Достижения (Что удалось и чем гордишься?)";
    item5.isBold = false;
    item5.inList = true;
    [dataArray addObject:item5];
    
    NFResultInfoItem *item6 = [[NFResultInfoItem alloc] init];
    item6.title = @"Открытия (Что стало новым? В себе, в людях, в событиях…)";
    item6.isBold = false;
    item6.inList = true;
    [dataArray addObject:item6];
    
    NFResultInfoItem *item7 = [[NFResultInfoItem alloc] init];
    item7.title = @"Люди (Все, кто оказал на тебя влияние. Реальные люди и выдуманные персонажи)";
    item7.isBold = false;
    item7.inList = true;
    [dataArray addObject:item7];
    
    NFResultInfoItem *item8 = [[NFResultInfoItem alloc] init];
    item8.title = @"Цитаты и мысли (То, что сегодня зацепило, стало важным в речах людей, прочитанном, диалогах)";
    item8.isBold = false;
    item8.inList = true;
    [dataArray addObject:item8];
    
    NFResultInfoItem *item9 = [[NFResultInfoItem alloc] init];
    item9.title = @"Зона роста (То, что дало мне возможность сделать шаг из своей «зоны комфорта»)";
    item9.isBold = false;
    item9.inList = true;
    [dataArray addObject:item9];
    
    NFResultInfoItem *item10 = [[NFResultInfoItem alloc] init];
    item10.title = @"Порадовало (Об этом мы часто забываем, но именно это делает наш день чудесным. Это могут быть приятные мелочи, без которых наши дни были бы другими)";
    item10.isBold = false;
    item10.inList = true;
    [dataArray addObject:item10];
    
    NFResultInfoItem *item11 = [[NFResultInfoItem alloc] init];
    item11.title = @"Интересное (То, что хотелось изучить, почитать, посмотреть. Новые направления в темах, в общении)";
    item11.isBold = false;
    item11.inList = true;
    [dataArray addObject:item11];
    
    NFResultInfoItem *item12 = [[NFResultInfoItem alloc] init];
    item12.title = @"Благодарность (Это один из важнейших пунктов для осознания всего происходящего, замечания приятных мелочей, понимания важности каждого момента и его причинности)";
    item12.isBold = false;
    item12.inList = true;
    [dataArray addObject:item12];
    
    
    return dataArray;
}

@end
