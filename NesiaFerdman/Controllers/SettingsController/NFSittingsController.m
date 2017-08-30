//
//  NFSittingsController.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/21/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFSittingsController.h"
#import "GTMOAuth2ViewControllerTouch.h"
#import "NFMenuItem.h"
#import "NFMenuElements.h"
#import "NFGoogleSyncManager.h"
#import "NFMenuCell.h"
#import "NFStyleKit.h"
#import "NFSettingDetailController.h"
#import "NFMenuElements.h"



@interface NFSittingsController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *email;
@end


@implementation NFSittingsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Меню";
//    [self setUserInfo];
    self.dataArray = [NSMutableArray array];
    [self.tableView registerNib:[UINib nibWithNibName:@"NFMenuCell" bundle:nil] forCellReuseIdentifier:@"NFMenuCell"];
    self.tableView.tableFooterView = [UIView new];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addDataToDisplay];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitAction) name:DELETE_USER object:nil];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DELETE_USER object:nil];

}

- (void)exitAction {
    [NFMenuElements navigateToScreenWithIndex:Exit target:self];
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
    // for demo

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
    self.email.text = [[NFGoogleSyncManager sharedManager] getUserEmail];
//    UIImage *avatar = [[NFGoogleSyncManager sharedManager] getUserAvatar];
//    if (avatar != nil) {
//        self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.height/2;
//        self.avatarImageView.layer.borderColor = [NFStyleKit bASE_GREEN].CGColor;
//        self.avatarImageView.layer.borderWidth = 2.f;
//        self.avatarImageView.layer.masksToBounds = YES;
//        [self.avatarImageView setImage:avatar];
//    } else {
//        [self.avatarImageView setImage:[UIImage imageNamed:@"user_icon.png"]];
//    }
}


@end
