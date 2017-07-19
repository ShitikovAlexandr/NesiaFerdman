//
//  NFCalendarListController.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 7/18/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFCalendarListController.h"
#import "NFCalendarListDataSource.h"
#import "UIBarButtonItem+FHButtons.h"

@interface NFCalendarListController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NFCalendarListDataSource *dataSource;

@end

@implementation NFCalendarListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Список календарей";
    _tableView.tableFooterView = [UIView new];
    [self.navigationItem setLeftButtonType:FHLeftNavigationButtonTypeBack controller:self];
    _dataSource = [[NFCalendarListDataSource alloc] initWithTableView:_tableView target:self];
    [_dataSource updateData];
}

@end
