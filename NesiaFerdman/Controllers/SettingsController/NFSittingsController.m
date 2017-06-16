//
//  NFSittingsController.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 4/21/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFSittingsController.h"
#import "GTMOAuth2ViewControllerTouch.h"
#import "NFMenuItem.h"
#import "NFMenuElements.h"
#import "NFGoogleManager.h"
#import "NFMenuCell.h"

@interface NFSittingsController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UILabel *email;
@end


@implementation NFSittingsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Меню";
    [self setUserInfo];
    self.dataArray = [NSMutableArray array];
    [self.tableView registerNib:[UINib nibWithNibName:@"NFMenuCell" bundle:nil] forCellReuseIdentifier:@"NFMenuCell"];
    self.tableView.tableFooterView = [UIView new];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addDataToDisplay];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NFMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NFMenuCell"];

    NFMenuItem *item = [self.dataArray objectAtIndex:indexPath.row];
    [cell addDataToCell:item];
    return cell;
}

#pragma mark - UITableViewDataSource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [NFMenuElements navigateToScreenWithIndex:indexPath.row target:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

#pragma mark - Helpers

- (void)addDataToDisplay {
    [self.dataArray removeAllObjects];
    NFMenuElements *menuElements = [[NFMenuElements alloc] init];
    [self.dataArray addObjectsFromArray:menuElements.itemsArray];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationBottom];
}

- (void)setUserInfo {
     GTMOAuth2Authentication *user = [NFGoogleManager sharedManager].service.authorizer;
    self.email.text = [user.parameters objectForKey:@"email"];
}

@end
