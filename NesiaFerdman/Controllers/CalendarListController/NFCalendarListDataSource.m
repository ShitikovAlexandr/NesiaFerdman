//
//  NFCalendarListDataSource.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 7/18/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFCalendarListDataSource.h"
#import "NFGoogleCalendar.h"
#import "NFNSyncManager.h"
#import "NFTCalendarListCell.h"
#import "NFDataSourceManager.h"

@interface NFCalendarListDataSource () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) UIViewController *target;
@end

@implementation NFCalendarListDataSource

- (instancetype)initWithTableView:(UITableView*)tableView target:(UIViewController*)target {
    self = [super init];
    if (self) {
        _target = target;
        _dataArray = [NSMutableArray new];
        _tableView = tableView;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"NFTCalendarListCell" bundle:nil] forCellReuseIdentifier:@"NFTCalendarListCell"];
    }
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NFTCalendarListCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"NFTCalendarListCell"];
    NFGoogleCalendar *calendar = [_dataArray objectAtIndex:indexPath.row];
    cell.calendarSwitcher.tag = indexPath.row;
    [cell.calendarSwitcher addTarget:self action:@selector(switchToggled:) forControlEvents:UIControlEventValueChanged];
    [cell addDataToCell:calendar];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - Helpers

- (void)updateData {
    [_dataArray removeAllObjects];
    [_dataArray addObjectsFromArray:[[NFDataSourceManager sharedManager] getCalendarList]];
    [_tableView reloadData];
}

- (void) switchToggled:(UISwitch *)sender {
    NFGoogleCalendar *calendar = [_dataArray objectAtIndex:sender.tag];
    calendar.selectedInApp = sender.isOn;
    [[NFNSyncManager sharedManager] writeCalendarToDataBase:calendar];
}




@end
