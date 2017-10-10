//
//  NFResultInfoController.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 10/2/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFResultInfoController.h"
#import "UIBarButtonItem+FHButtons.h"
#import "NFResultInfoDataSource.h"
#import "NFResultInfoCell.h"

#define kNFResultInfoControllerTitle @"О итогах"

@interface NFResultInfoController ()
@property (strong, nonatomic) NFResultInfoDataSource *dataSource;
@property (strong, nonatomic) NSMutableArray *dataArray;
@end

@implementation NFResultInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kNFResultInfoControllerTitle;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedRowHeight = 20.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.navigationItem setLeftButtonType:FHLeftNavigationButtonTypeBack controller:self];
    self.dataArray = [NSMutableArray new];
    self.dataSource = [[NFResultInfoDataSource alloc] init];
    [self.dataArray addObjectsFromArray:[self.dataSource getData]];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NFResultInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NFResultInfoCell"];
    if (!cell) {
        cell = [[NFResultInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NFResultInfoCell"];
    }
    NFResultInfoItem *item = [self.dataArray objectAtIndex:indexPath.row];
    [cell addDataToCell:item];
    return cell;
}





@end
