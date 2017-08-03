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
#import "NFActivityIndicatorView.h"
#import "NFNSyncManager.h"

@interface NFCalendarListController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NFCalendarListDataSource *dataSource;
@property (strong, nonatomic) NFActivityIndicatorView *indicator;

@end

@implementation NFCalendarListController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.tableFooterView = [UIView new];
    _dataSource = [[NFCalendarListDataSource alloc] initWithTableView:_tableView target:self];
    if (!_isFirstRun) {
        self.title = @"Список календарей";
        [self.navigationItem setLeftButtonType:FHLeftNavigationButtonTypeBack controller:self];
        [_dataSource updateData];
    } else {
        self.title = @"Выберите календари";
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Готово" style:UIBarButtonItemStylePlain target:self action:@selector(exit)];
        self.navigationItem.rightBarButtonItem = doneButton;
        if (_isCompliteDownload) {
            [_indicator endAnimating];
            [_dataSource updateData];
        } else {
            _indicator = [[NFActivityIndicatorView alloc] initWithView:self.view];
            [_indicator startAnimating];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateByNotification) name:END_UPDATE object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:END_UPDATE object:nil];
}

- (void)updateByNotification {
    [_indicator endAnimating];
    if (!_isCompliteDownload) {
        [_dataSource updateData];
    }
}

- (void)exit {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
