//
//  NFStatisticRandomPeriodDataSource.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 7/18/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFStatisticRandomPeriodDataSource.h"
#import "NFStatisticRandomPeriodDataSource.h"
#import "NFStatisticMainCell.h"
#import "NFTaskManager.h"
#import "NFStatisticDetailController.h"

@interface NFStatisticRandomPeriodDataSource () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) id target;
@property (strong, nonnull) NSMutableDictionary *dataDictionary;
@property (strong, nonatomic) NSMutableArray *valuesArray;
@property (strong, nonatomic) NSMutableArray *selectedDateArray;
@end

@implementation NFStatisticRandomPeriodDataSource

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
        _selectedDateArray = [NSMutableArray array];
        _dataDictionary = [NSMutableDictionary dictionary];
        [self.tableView registerNib:[UINib nibWithNibName:@"NFStatisticMainCell" bundle:nil] forCellReuseIdentifier:@"NFStatisticMainCell"];
    }
    return self;
}

- (void)setSelectedDate:(NSMutableArray*)dateArray {
    _selectedDateArray = dateArray;
    [self addDataToDisplay];
}

- (void)addDataToDisplay {
    [self.dataDictionary removeAllObjects];
    NSMutableArray* eventsArray = [NSMutableArray array];
    for (NSDate *day in _selectedDateArray) {
        [eventsArray addObjectsFromArray: [[NFTaskManager sharedManager] getTasksForDay:day]];
    }
    [self.dataDictionary setDictionary:[[NFTaskManager sharedManager] eventSortedByValue:eventsArray]];
    [self.tableView reloadData];
}

#pragma mark - navigation

- (void)navigateToDitailScreenWithIndexPath:(NSIndexPath*)indexPath {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NFStatisticMainCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NFStatisticDetailController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"NFStatisticDetailController"];
    viewController.selectedDateArray = [NSMutableArray array];
    [viewController.selectedDateArray addObjectsFromArray:_selectedDateArray];
    viewController.value = cell.value;
    viewController.type = OtherStatistic;
    [_target presentViewController:viewController animated:YES completion:nil];
}

@end
