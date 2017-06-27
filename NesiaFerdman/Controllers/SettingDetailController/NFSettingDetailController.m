//
//  NFSettingDetailController.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 6/27/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFSettingDetailController.h"
#import "UIBarButtonItem+FHButtons.h"


@interface NFSettingDetailController ()

@property (strong, nonatomic) NSMutableArray *dataArray;

@property (weak, nonatomic) IBOutlet UILabel *googleSyncLabel;
@property (weak, nonatomic) IBOutlet UILabel *googleWriteLabel;
@property (weak, nonatomic) IBOutlet UILabel *googleDeleteLabel;
@property (weak, nonatomic) IBOutlet UILabel *updateLabel;

@property (weak, nonatomic) IBOutlet UISwitch *googleSyncSwitcher;
@property (weak, nonatomic) IBOutlet UISwitch *googleWriteSwitcher;
@property (weak, nonatomic) IBOutlet UISwitch *googleDeleteSwitcher;
@property (weak, nonatomic) IBOutlet UIButton *updateButton;

@end

@implementation NFSettingDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addDataToDataSource];
    [self.navigationItem setLeftButtonType:FHLeftNavigationButtonTypeBack controller:self];
    self.tableView.tableFooterView = [UIView new];
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!_googleSyncSwitcher.isOn && indexPath.row == 1) {
        return 0;
    } else if (!_googleSyncSwitcher.isOn && indexPath.row == 2) {
        return 0;
    } else {
        return 44;
    }
}


- (void)addDataToDataSource {
    self.title = @"Настройки";
    _googleSyncLabel.text = @"Синхронизация с Google";
    _googleWriteLabel.text = @"Запись в Google";
    _googleDeleteLabel.text = @"Удаление с Google";
    _updateLabel.text = @"Обновить";
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
    NSLog(@"syncAction %hhd", sender.isOn);
    [self changeTableViewState];
}

- (void)writeAction:(UISwitch*)sender {
    NSLog(@"writeAction %hhd", sender.isOn);

}

- (void)deleteAction:(UISwitch*)sender {
    NSLog(@"deleteAction  %hhd", sender.isOn);

}

- (void)updateAction {
    NSLog(@"updateAction");

}


@end
