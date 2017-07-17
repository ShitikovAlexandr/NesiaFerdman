//
//  NFStatisticMonthDataSource.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 7/17/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFStatisticMonthDataSource.h"
#import "NFSettingManager.h"
#import "NFStatisticMainCell.h"
#import "NFValuesFilterView.h"
#import "NFTaskManager.h"
#import "NFStatisticDetailController.h"

@interface NFStatisticMonthDataSource() <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSDate *selectedDate;
@property (strong, nonatomic) NFDateModel *dateLimits;
@property (strong, nonatomic) id target;
@property (strong, nonnull) NSMutableDictionary *dataDictionary;
@property (strong, nonatomic) NSMutableArray *valuesArray;
@end

@implementation NFStatisticMonthDataSource

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([NFTaskManager sharedManager].selectedValuesArray.count) {
        return [NFTaskManager sharedManager].selectedValuesArray.count;
    } else {
        return [[NFTaskManager sharedManager] getAllValues].count + 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NFStatisticMainCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"NFStatisticMainCell"];
    [cell addDatatoCellwithDictionary:_dataDictionary indexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self navigateToDitailScreenWithIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 190.0;
}

#pragma mark - Helpers

- (instancetype)initWithTableView:(UITableView*)tableView target:(id)target {
    if (self) {
        _target = target;
        _tableView = tableView;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _dataArray = [NSMutableArray new];
        _dateLimits = [[NFDateModel alloc] initWithStartDate:[NFSettingManager getMinDate]
                                                     endDate:[NFSettingManager getMaxDate]];
        _dataArray = [NSMutableArray array];
        _dataDictionary = [NSMutableDictionary dictionary];
        [self.tableView registerNib:[UINib nibWithNibName:@"NFStatisticMainCell" bundle:nil] forCellReuseIdentifier:@"NFStatisticMainCell"];
    }
    return self;
}

- (void)setSelectedDate:(NSDate*)date {
    _selectedDate = date;
    [self addDataToDisplay];
}

- (void)addDataToDisplay {
    [self.dataDictionary removeAllObjects];
    NSMutableArray* eventsArray = [NSMutableArray array];
    [eventsArray addObjectsFromArray: [[NFTaskManager sharedManager] getTaskForMonth:_selectedDate]];
    [self.dataDictionary setDictionary:[[NFTaskManager sharedManager] eventSortedByValue:eventsArray]];
    [self.tableView reloadData];
}

#pragma mark - navigation

- (void)navigateToDitailScreenWithIndexPath:(NSIndexPath*)indexPath {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NFStatisticMainCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NFStatisticDetailController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"NFStatisticDetailController"];
    viewController.selectedDate = _selectedDate;
    viewController.value = cell.value;
    viewController.type = MonthStatistic;
    [_target presentViewController:viewController animated:YES completion:nil];
}





@end
