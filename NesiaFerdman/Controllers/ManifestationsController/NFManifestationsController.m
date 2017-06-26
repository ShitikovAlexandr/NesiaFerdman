//
//  NFManifestationsController.m
//  NesiaFerdman
//
//  Created by alex on 25.06.17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFManifestationsController.h"
#import "NFTaskManager.h"
#import "NFHeaderForTaskSection.h"
#import "NFManifestation.h"
#import "UIBarButtonItem+FHButtons.h"


@interface NFManifestationsController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation NFManifestationsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSMutableArray array];
    self.title = @"Проявления";
    [self.navigationItem setLeftButtonType:FHLeftNavigationButtonTypeBack controller:self];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0;     [self addDataToDisplay];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count > 0 ? _dataArray.count : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sectionData = _dataArray.count > 0 ? [self.dataArray objectAtIndex:section] : [NSArray array];
    return sectionData.count > 0 ? sectionData.count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]  initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    NSArray *array = [NSArray arrayWithArray:[_dataArray objectAtIndex:indexPath.section]];
    NFManifestation *item = [array objectAtIndex:indexPath.row];
    cell.textLabel.text = item.name;

    return cell;
}

- (void)addDataToDisplay {
    [_dataArray removeAllObjects];
    [_dataArray addObjectsFromArray:[[NFTaskManager sharedManager] getAllManifestations]];
    [_tableView reloadData];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [NFHeaderForTaskSection headerSize];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (_dataArray.count > 0) {
        NSArray *array = [NSArray arrayWithArray:[_dataArray objectAtIndex:section]];
        NFManifestation *item = [array firstObject];
        return item.categoryTitle;
    } else {
        return @"";
    }
}


@end
