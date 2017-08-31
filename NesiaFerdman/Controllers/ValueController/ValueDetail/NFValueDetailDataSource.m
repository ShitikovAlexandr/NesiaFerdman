//
//  NFValueDetailDataSource.m
//  NesiaFerdman
//
//  Created by Alex on 30.07.17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFValueDetailDataSource.h"
#import "UIBarButtonItem+FHButtons.h"
#import "NFAddValueCategoryController.h"
#import "NFDataSourceManager.h"
#import "NFValueDetailCell.h"
#import "NFResultCell.h"
#import "NFNSyncManager.h"

@interface NFValueDetailDataSource () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView* tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NFValueDetailController *target;

@end

@implementation NFValueDetailDataSource

- (instancetype)initWithTableView:(UITableView*)tableView target:(NFValueDetailController*)target {
    self = [super init];
    if (self) {
        _dataArray = [NSMutableArray new];
        _tableView = tableView;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 60;
        self.tableView.tableFooterView = [UIView new];
        _target = target;
    }
    return self;
}

- (void)initButtons {
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonAction)];
    addButton.tintColor = [UIColor whiteColor];
    _target.navigationItem.rightBarButtonItem = addButton;
    [_target.navigationItem setLeftButtonType:FHLeftNavigationButtonTypeBack controller:_target];
}

- (void)addButtonAction {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"NewMain" bundle:nil];
    NFAddValueCategoryController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"NFAddValueCategoryController"];
    viewController.value = _target.value;
    [_target.navigationController pushViewController:viewController animated:YES];
    
}

- (void) navigateToEditscreenWithManifestation:(NFNManifestation*)manifestation {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"NewMain" bundle:nil];
    NFAddValueCategoryController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"NFAddValueCategoryController"];
    viewController.value = _target.value;
    viewController.manifestation = manifestation;
    [_target.navigationController pushViewController:viewController animated:YES];
}

- (void)getData {
   // [[NFNSyncManager sharedManager] updateManifestationDataSource];
    [_dataArray removeAllObjects];
        [_dataArray addObjectsFromArray:[[NFDataSourceManager sharedManager] getManifestationListWithValue:_target.value]];
        [_tableView reloadData];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationBottom];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count > 0 ? _dataArray.count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NFResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NFResultCell"];
    if (!cell) {
        cell = [[NFResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NFResultCell"];
    }
    if (_dataArray.count > 0) {
        NFNManifestation *item = [_dataArray objectAtIndex:indexPath.row];
        [cell addManifestation:item];
    } else {
        [cell addManifestation:nil];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_dataArray.count > 0) {
        NFResultCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [self navigateToEditscreenWithManifestation:cell.manifestation];
    } else {
        [self addButtonAction];
    }
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return [NFValueDetailCell cellSize];
//}



@end
