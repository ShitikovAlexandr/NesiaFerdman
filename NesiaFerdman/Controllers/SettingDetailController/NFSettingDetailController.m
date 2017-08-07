//
//  NFSettingDetailController.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 6/27/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFSettingDetailController.h"
#import "UIBarButtonItem+FHButtons.h"
#import "NFSettingManager.h"
#import "NFNSyncManager.h"
#import "NFActivityIndicatorView.h"
#import "NotifyList.h"
#import "NFCalendarListController.h"
#import "NFTermsController.h"

@interface NFSettingDetailController ()

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UILabel *googleSyncLabel;
@property (weak, nonatomic) IBOutlet UILabel *googleWriteLabel;
@property (weak, nonatomic) IBOutlet UILabel *googleDeleteLabel;
@property (weak, nonatomic) IBOutlet UILabel *updateLabel;
@property (weak, nonatomic) IBOutlet UILabel *GoogleCalendarListLabel;
@property (weak, nonatomic) IBOutlet UILabel *termsLabel;
@property (weak, nonatomic) IBOutlet UILabel *supportLabel;



@property (weak, nonatomic) IBOutlet UISwitch *googleSyncSwitcher;
@property (weak, nonatomic) IBOutlet UISwitch *googleWriteSwitcher;
@property (weak, nonatomic) IBOutlet UISwitch *googleDeleteSwitcher;
@property (weak, nonatomic) IBOutlet UIButton *updateButton;
@property (strong, nonatomic) NFActivityIndicatorView *indicator;
@end

@implementation NFSettingDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addDataToDataSource];
    [self.navigationItem setLeftButtonType:FHLeftNavigationButtonTypeBack controller:self];
    self.tableView.tableFooterView = [UIView new];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endUpdate) name:END_UPDATE_DATA object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:END_UPDATE_DATA object:nil];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!_googleSyncSwitcher.isOn && indexPath.row == 1) {
        return 0;
    } else if (!_googleSyncSwitcher.isOn && indexPath.row == 2) {
        return 0;
    } else if (!_googleSyncSwitcher.isOn && indexPath.row == 3) {
        return 0;
    } else {
        return 44;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        [self navigateToCalendarList];
    } else if (indexPath.row == 5) {
        //Условия использования
        [self navigateToTermsScreen];
    } else if (indexPath.row == 6) {
        //Связаться с службой поддержки
        [self sendEmail];
    }
}

- (void)addDataToDataSource {
    self.title = @"Настройки";
    _googleSyncLabel.text = @"Синхронизация с Google";
    _googleWriteLabel.text = @"Запись в Google";
    _googleDeleteLabel.text = @"Удаление с Google";
    _updateLabel.text = @"Обновить";
    _GoogleCalendarListLabel.text = @"Список доступных календарей";
    _termsLabel.text = @"Условия использования";
    _supportLabel.text = @"Связаться с службой поддержки";
    
    [_googleSyncSwitcher setOn:[NFSettingManager isOnGoogleSync]];
    [_googleWriteSwitcher setOn:[NFSettingManager isOnWriteToGoogle]];
    [_googleDeleteSwitcher setOn:[NFSettingManager isOnDeleteFromGoogle]];
    
    [_googleSyncSwitcher addTarget:self action:@selector(syncAction:) forControlEvents:UIControlEventValueChanged];
    [_googleWriteSwitcher addTarget:self action:@selector(writeAction:) forControlEvents:UIControlEventValueChanged];
    [_googleDeleteSwitcher addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventValueChanged];
    [_updateButton addTarget:self action:@selector(updateAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)changeTableViewState {
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

#pragma mark - Actions

- (void)syncAction:(UISwitch*)sender {
    if (sender.isOn) {
        [NFSettingManager setOnGoogleSync];
        [[NFNSyncManager sharedManager] updateData];
        
    } else {
        [NFSettingManager setOffGoogleSync];
    }
    [self changeTableViewState];
}

- (void)writeAction:(UISwitch*)sender {
    if (sender.isOn) {
        [NFSettingManager setOnWriteToGoogle];
    } else {
        [NFSettingManager setOffWriteToGoogle];
    }
}

- (void)deleteAction:(UISwitch*)sender {
    if (sender.isOn) {
        [NFSettingManager setOnDeleteFromGoogle];
    } else {
        [NFSettingManager setOffDeleteFromGoogle];
    }
}

- (void)updateAction {
    _indicator = [[NFActivityIndicatorView alloc] initWithView:self.view];
    [_indicator startAnimating];
    [[NFNSyncManager sharedManager] updateData];
    [self endUpdate];
}

- (void)endUpdate {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_indicator endAnimating];
    });
}

- (void)navigateToCalendarList {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
                                @"NewMain" bundle:[NSBundle mainBundle]];
    NFCalendarListController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"NFCalendarListController"];
    UINavigationController *navController = [storyboard instantiateViewControllerWithIdentifier:@"NFCalendarListControllerNav"];
    [navController setViewControllers:@[viewController]];
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)navigateToTermsScreen {
    NSLog(@"Navigate to terms screen");
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
                                @"NewMain" bundle:[NSBundle mainBundle]];
    NFTermsController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"NFTermsController"];
    UINavigationController *navController = [storyboard instantiateViewControllerWithIdentifier:@"NFTermsControllerNav"];
    [navController setViewControllers:@[viewController]];
    [self presentViewController:navController animated:YES completion:nil];
    
}

- (void)sendEmail {
    NSURL* mailURL = [NSURL URLWithString:@"mailto:Inna.Drozd@gmail.com"];
    if ([[UIApplication sharedApplication] canOpenURL:mailURL]) {
        [[UIApplication sharedApplication] openURL:mailURL];
    }
}


@end
