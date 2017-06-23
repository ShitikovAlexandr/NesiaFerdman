//
//  NFAboutController.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 6/23/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFAboutController.h"
#import "UIBarButtonItem+FHButtons.h"
#import <Crashlytics/Crashlytics.h>

@interface NFAboutController ()

@end

@implementation NFAboutController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"О нас";
    [self.navigationItem setLeftButtonType:FHLeftNavigationButtonTypeBack controller:self];
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(20, 50, 100, 30);
    [button setTitle:@"Crash" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(crashButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
