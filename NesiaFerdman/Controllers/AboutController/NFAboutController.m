//
//  NFAboutController.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 6/23/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFAboutController.h"
#import "UIBarButtonItem+FHButtons.h"

@interface NFAboutController ()

@end

@implementation NFAboutController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"О нас";
    [self.navigationItem setLeftButtonType:FHLeftNavigationButtonTypeBack controller:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
