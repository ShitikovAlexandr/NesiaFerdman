//
//  NFValueDetailController.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 7/6/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFValueDetailController.h"
#import "NFManifestation.h"
#import "NFSyncManager.h"
#import "NFAddValueCategoryController.h"
#import "UIBarButtonItem+FHButtons.h"
#import "NFValueDetailCell.h"


NSString * const identifier = @"Cell";

@interface NFValueDetailController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@end

@implementation NFValueDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _value.valueTitle;
     self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [UIView new];
    _dataArray = [NSMutableArray new];
    [self initButtons];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getDataWithValue:_value];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count > 0 ? _dataArray.count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NFValueDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[NFValueDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (_dataArray.count > 0) {
        NFManifestation *item = [_dataArray objectAtIndex:indexPath.row];
        [cell addDataToCell:item];
    } else {
        [cell addDataToCell:nil];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_dataArray.count > 0) {
        NFValueDetailCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [self navigateToEditscreenWithManifestation:cell.manifestation];
    } else {
        [self addButtonAction];
    }
}

#pragma mark - Helpers

- (void)getDataWithValue:(NFValue*)value {
    [_dataArray removeAllObjects];
    [_dataArray addObjectsFromArray:_value.manifestations];
    [_tableView reloadData];
}

- (void)initButtons {
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonAction)];
    addButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = addButton;
    
    [self.navigationItem setLeftButtonType:FHLeftNavigationButtonTypeBack controller:self];

}

- (void)addButtonAction {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"NewMain" bundle:nil];
    NFAddValueCategoryController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"NFAddValueCategoryController"];
    viewController.value = _value;
    [self.navigationController pushViewController:viewController animated:YES];
    
}

- (void) navigateToEditscreenWithManifestation:(NFManifestation*)manifestation {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"NewMain" bundle:nil];
    NFAddValueCategoryController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"NFAddValueCategoryController"];
    viewController.value = _value;
    viewController.manifestation = manifestation;
    [self.navigationController pushViewController:viewController animated:YES];
}


@end
