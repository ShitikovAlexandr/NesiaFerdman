//
//  NFResultDayController.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 7/7/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFResultDayController.h"
#import "NFHeaderView.h"
#import "NFResultMenuCell.h"
#import "NFResultDetailController.h"
#import "NFTaskManager.h"

NSString *const identifier = @"Cell";

@interface NFResultDayController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet NFHeaderView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@end

@implementation NFResultDayController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NFResultMenuCell *cell  = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[NFResultMenuCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    NFResultCategory *category = [_dataArray objectAtIndex:indexPath.row];
    [cell addDataToCell:category date:[self.headerView.dateSourse.weekArray objectAtIndex:_headerView.selectedIndex]];
    return cell;

}



#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NFResultCategory *category = [_dataArray objectAtIndex:indexPath.row];
    [self navigateToDitailCategory:category];
}

#pragma mark - Helpers

- (void) addDataToDisplay {
    [_dataArray removeAllObjects];
    [_dataArray addObjectsFromArray:[[NFTaskManager sharedManager] getAllResultCategory]];
    [self.tableView reloadData];
}


- (void)navigateToDitailCategory:(NFResultCategory*)category {
    NFResultDetailController *viewCotroller = [self.storyboard instantiateViewControllerWithIdentifier:@"NFResultDetailController"];
    viewCotroller.week = [self.headerView.dateSourse.weekArray objectAtIndex:_headerView.selectedIndex];
    viewCotroller.selectedCategory = category;
    [self.navigationController pushViewController:viewCotroller animated:YES];
}




@end
