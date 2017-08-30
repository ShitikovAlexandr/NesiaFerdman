//
//  NFCalendarListController.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/18/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFCalendarListController.h"
#import "NFCalendarListDataSource.h"
#import "UIBarButtonItem+FHButtons.h"
#import "NFNSyncManager.h"

#define kNFCalendarListControllerFirstTitle @"Выберите календари"
#define kNFCalendarListControllerMainTitle  @"Список календарей"
#define kNFCalendarListControllerDone       @"Готово"

@interface NFCalendarListController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NFCalendarListDataSource *dataSource;
@property (strong, nonatomic) UIBarButtonItem *doneButton;

@end

@implementation NFCalendarListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _indicator = [[NFActivityIndicatorView alloc] initWithView:self.view];
    [_indicator startAnimating];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateByNotification) name:END_UPDATE object:nil];
    
    _tableView.tableFooterView = [UIView new];
    _dataSource = [[NFCalendarListDataSource alloc] initWithTableView:_tableView target:self];
    [self.navigationItem setLeftButtonType:FHLeftNavigationButtonTypeBack controller:self];
    if (!_isFirstRun) {
        self.title = kNFCalendarListControllerMainTitle;
        [_dataSource updateData];
    } else {
        self.title = kNFCalendarListControllerFirstTitle;
        _doneButton = [[UIBarButtonItem alloc] initWithTitle:kNFCalendarListControllerDone style:UIBarButtonItemStylePlain target:self action:@selector(exit)];
        self.navigationItem.rightBarButtonItem = _doneButton;
        [_dataSource updateData];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NFNSyncManager sharedManager] updateData];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:END_UPDATE object:nil];
    [_indicator endAnimating];
}

- (void)updateByNotification {
    [_dataSource updateData];
}

- (void)exit {
    [self.navigationController pushViewController:_nextController animated:YES];
}

@end
