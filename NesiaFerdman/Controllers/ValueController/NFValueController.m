//
//  NFValueController.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/8/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFValueController.h"
#import "TPKeyboardAvoidingTableView.h"
#import "NFValueMainDataSource.h"

#define kNFValueControllerTitle @"Мои ценности"

@interface NFValueController ()
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingTableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableArray *deletedValues;
@property (strong, nonatomic) NFValueMainDataSource *dataSource;
@end

@implementation NFValueController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSource = [[NFValueMainDataSource alloc] initWithTableView:_tableView target:self];
    self.title = kNFValueControllerTitle;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)updateData {
    [_dataSource getData];
    [_dataSource setScreenState:_screenState];
}


@end
