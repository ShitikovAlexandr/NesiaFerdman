//
//  NFAboutValueDataSource.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 9/11/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//


#define ABOUT_VALUE_TEXT1 @"Основа нашего коуч календаря - это определение ваших ценностей и осознанное применение  их в вашей жизни. Перед тем, как начать пользоваться приложением, необходимо определить свои ценности. Выберете, пожалуйста, от 7 до 11 ценностей из предложенного списка, либо добавьте  свои."
#define ABOUT_VALUE_TEXT2 @"Наши ценности не появляются из ниоткуда, они постепенно формируются социумом и следуют за человеком всю его жизнь. Большинство из них стабильны, однако в жизни каждого из нас бывают важные  моменты, когда происходит переоценка целей и приоритетов. И тут самое время пересмотреть ценности, понять, какие из них стали более приоритетными, а какие потеряли свою значимость . Такой самоанализ очень важен, поскольку из ценностей появляются цели, цели разворачиваются в планы, а планы воплощаются в жизнь. Жизненные ценности – это то, что лежит в основе мотивации, то, ради чего мы готовы прилагать усилия и то, что дает нам энергию и ресурсы."
#define ABOUT_VALUE_TEXT3 @"Понимание своих ценностей:\n\n- Помогает делать выбор.\n- Позволяет сохранить и привнести в жизнь то, чего ты по настоящему хочешь.\n- Дает возможность направить усилия и время на то, что  действительно приносит радость и удовлетворение."
#define ABOUT_VALUE_TEXT4 @"Реализуя свои ценности в течении своей жизни мы можем ощущать, что живем свою жизнь и именно ты являешься директором своей жизни!"
#define ABOUT_VALUE_TEXT5 @""



#import "NFAboutValueDataSource.h"

@interface NFAboutValueDataSource() <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NFAboutValueInfoController *target;

@end

@implementation NFAboutValueDataSource

- (instancetype)initWithTableView:(UITableView*)tableView target:(NFAboutValueInfoController*)target {
    self = [super init];
    if (self) {
        _tableView = tableView;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 40.0;
        _tableView.tableFooterView = [UIView new];
        _target = target;
    }
    return self;
}

#pragma  mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    cell.textLabel.text = [self setTextWithIndex:indexPath.row];
    return cell;
}


#pragma  mark - Helpers

- (NSString*)setTextWithIndex:(NSInteger)index {
    switch (index) {
        case 0: {
            return ABOUT_VALUE_TEXT1;
            break;
        }
        case 1: {
            return ABOUT_VALUE_TEXT2;
            break;
        }
        case 2: {
            return ABOUT_VALUE_TEXT3;
            break;
        }
        case 3: {
            return ABOUT_VALUE_TEXT4;
            break;
        }
            
        default:
            break;
    }
    return @"";
}

#pragma mark - static data




@end
