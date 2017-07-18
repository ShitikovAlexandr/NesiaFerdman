//
//  NFCalendarListController.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 7/18/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFCalendarListController.h"
#import "NFSettingManager.h"

@interface NFCalendarListController ()

@end

@implementation NFCalendarListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [NFSettingManager getAllAvalibleCalendars];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
