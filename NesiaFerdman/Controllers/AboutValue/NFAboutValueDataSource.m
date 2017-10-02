//
//  NFAboutValueDataSource.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 9/11/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//


#define ABOUT_VALUE_TEXT1 @"\tОснова нашего коуч календаря - это определение ваших ценностей и осознанное применение  их в вашей жизни. Перед тем, как начать пользоваться приложением, необходимо определить свои ценности. Выберете, пожалуйста, от 7 до 11 ценностей из предложенного списка, либо добавьте  свои."
#define ABOUT_VALUE_TEXT2 @"\tНаши ценности не появляются из ниоткуда, они постепенно формируются социумом и следуют за человеком всю его жизнь. Большинство из них стабильны, однако в жизни каждого из нас бывают важные  моменты, когда происходит переоценка целей и приоритетов. И тут самое время пересмотреть ценности, понять, какие из них стали более приоритетными, а какие потеряли свою значимость . Такой самоанализ очень важен, поскольку из ценностей появляются цели, цели разворачиваются в планы, а планы воплощаются в жизнь. Жизненные ценности – это то, что лежит в основе мотивации, то, ради чего мы готовы прилагать усилия и то, что дает нам энергию и ресурсы."
#define ABOUT_VALUE_TEXT3 @"Понимание своих ценностей:"
#define ABOUT_VALUE_TEXT3_1 @"Помогает делать выбор.\n"
#define ABOUT_VALUE_TEXT3_2 @"Позволяет сохранить и привнести в жизнь то, чего ты по настоящему хочешь."
#define ABOUT_VALUE_TEXT3_3 @"Дает возможность направить усилия и время на то, что  действительно приносит радость и удовлетворение."

#define ABOUT_VALUE_TEXT4 @"\tРеализуя свои ценности в течении своей жизни мы можем ощущать, что живем свою жизнь и именно ты являешься директором своей жизни!"

#import "NFAboutValueDataSource.h"
#import "NFResultInfoCell.h"
#import "NFResultInfoItem.h"

@interface NFAboutValueDataSource() <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NFAboutValueInfoController *target;
@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation NFAboutValueDataSource

- (instancetype)initWithTableView:(UITableView*)tableView target:(NFAboutValueInfoController*)target {
    self = [super init];
    if (self) {
        _tableView = tableView;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 20.0;
        _tableView.tableFooterView = [UIView new];
        _target = target;
        _dataArray = [NSMutableArray new];
        [_dataArray addObjectsFromArray:[self getData]];
    }
    return self;
}

#pragma  mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NFResultInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NFResultInfoCell"];
    if (!cell) {
        cell = [[NFResultInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NFResultInfoCell"];
    }
    NFResultInfoItem *item = [_dataArray objectAtIndex:indexPath.row];
    [cell addDataToCell:item];
    return cell;
}


#pragma  mark - Helpers


#pragma mark - static data

- (NSArray*)getData {
    NSMutableArray *dataArray = [NSMutableArray new];
    
    NFResultInfoItem *item1 = [[NFResultInfoItem alloc] init];
    item1.title = ABOUT_VALUE_TEXT1;
    item1.isBold = false;
    item1.inList = false;
    [dataArray addObject:item1];
    
    NFResultInfoItem *item2 = [[NFResultInfoItem alloc] init];
    item2.title = ABOUT_VALUE_TEXT2;
    item2.isBold = false;
    item2.inList = false;
    [dataArray addObject:item2];
    
    NFResultInfoItem *item3 = [[NFResultInfoItem alloc] init];
    item3.title = ABOUT_VALUE_TEXT3;
    item3.isBold = true;
    item3.inList = false;
    [dataArray addObject:item3];
    
    //list
    NFResultInfoItem *item4 = [[NFResultInfoItem alloc] init];
    item4.title = ABOUT_VALUE_TEXT3_1;
    item4.isBold = false;
    item4.inList = true;
    [dataArray addObject:item4];
    
    NFResultInfoItem *item5 = [[NFResultInfoItem alloc] init];
    item5.title = ABOUT_VALUE_TEXT3_2;
    item5.isBold = false;
    item5.inList = true;
    [dataArray addObject:item5];
    
    NFResultInfoItem *item6 = [[NFResultInfoItem alloc] init];
    item6.title = ABOUT_VALUE_TEXT3_3;
    item6.isBold = false;
    item6.inList = true;
    [dataArray addObject:item6];
    
    // end list
    
    NFResultInfoItem *item7 = [[NFResultInfoItem alloc] init];
    item7.title = ABOUT_VALUE_TEXT4;
    item7.isBold = false;
    item7.inList = false;
    [dataArray addObject:item7];
    
    
    return dataArray;
}






@end
