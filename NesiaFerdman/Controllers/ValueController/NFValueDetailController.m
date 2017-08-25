//
//  NFValueDetailController.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/6/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFValueDetailController.h"
#import "NFNSyncManager.h"
#import "NFValueDetailDataSource.h"

@interface NFValueDetailController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NFValueDetailDataSource *dataSource;
@end

@implementation NFValueDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSource = [[NFValueDetailDataSource alloc] initWithTableView:_tableView target:self];
    self.title = _value.valueTitle;
    [_dataSource initButtons];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_dataSource getData];
}

@end
