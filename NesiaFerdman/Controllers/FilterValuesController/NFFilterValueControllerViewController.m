//
//  NFFilterValueControllerViewController.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/31/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFFilterValueControllerViewController.h"
#import "NFDataSourceManager.h"
#import "NFNValue.h"
#import "NFValueFilterCell.h"
#import "NFNSyncManager.h"

@interface NFFilterValueControllerViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (strong, nonatomic) NSMutableArray *valuesArray;
@property (strong, nonatomic) NSMutableArray *selectedValue;
@end

@implementation NFFilterValueControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Ценности";
    self.tableView.tableFooterView = [UIView new];
    _valuesArray = [NSMutableArray array];
    _selectedValue = [NSMutableArray array];
    [_selectedValue addObjectsFromArray:[[NFDataSourceManager sharedManager] getSelectedValueList]];
    [self getAllValues];
    [self.tableView registerNib:[UINib nibWithNibName:@"NFValueFilterCell" bundle:nil] forCellReuseIdentifier:@"NFValueFilterCell"];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _valuesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NFValueFilterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NFValueFilterCell"];
    NFNValue *val = [_valuesArray objectAtIndex:indexPath.row];
    [cell addData:val];
    cell.valueSwitcer.tag = indexPath.row;
    [cell.valueSwitcer addTarget:self action:@selector(switchToggled:) forControlEvents:UIControlEventValueChanged];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

#pragma mark - Helpers

- (IBAction)saveOrCancelAction:(UIBarButtonItem *)sender {
    if (sender.tag == 2) //save
    {
        [[NFNSyncManager sharedManager] resetSelectedValuesList];
        [[NFNSyncManager sharedManager] addValuesToSelectedList:_selectedValue];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)getAllValues {
    [_valuesArray addObjectsFromArray:[[NFDataSourceManager sharedManager] getValueList]];
    [_tableView reloadData];
}

- (void) switchToggled:(UISwitch *)sender {
    if ([sender isOn]) {
        NFNValue *value = [_valuesArray objectAtIndex:sender.tag];
        [_selectedValue addObject:value];
    } else {
        NSArray *temp = [NSArray arrayWithArray:_valuesArray];
        NFNValue *value = [_valuesArray objectAtIndex:sender.tag];
        for (NFNValue *val in temp) {
            if ([val.valueId isEqualToString:value.valueId]) {
                [_selectedValue removeObject:val];
            }
        }
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
