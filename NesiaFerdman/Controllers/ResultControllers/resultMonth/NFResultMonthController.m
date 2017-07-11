//
//  NFResultMonthController.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 7/7/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFResultMonthController.h"
#import "NFHeaderMonthView.h"
#import "NFSettingManager.h"

@interface NFResultMonthController ()
@property (strong, nonatomic) IBOutlet NFHeaderMonthView *headerView;

@end

@implementation NFResultMonthController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_headerView setListOfDateWithStart:[NFSettingManager getMinDate] end:[NFSettingManager getMaxDate]];
   
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


@end
