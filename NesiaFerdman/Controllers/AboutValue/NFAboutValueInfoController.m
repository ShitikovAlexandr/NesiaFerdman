//
//  NFAboutValueInfoController.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 9/11/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFAboutValueInfoController.h"
#import "NFAboutValueDataSource.h"

#define kNFAboutValueInfoDoneTittle @"Готово"
#define kNFAboutValueDataSourceTitle @"Про ценности"

@interface NFAboutValueInfoController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightNavButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NFAboutValueDataSource *dataSource;
@end

@implementation NFAboutValueInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  = kNFAboutValueDataSourceTitle;
    _dataSource = [[NFAboutValueDataSource alloc] initWithTableView:_tableView target:self];
    [_rightNavButton setTitle:kNFAboutValueInfoDoneTittle];
}

- (IBAction)navAction:(UIBarButtonItem *)sender {
    [self.navigationController pushViewController:_nextController animated:YES];
}

@end
