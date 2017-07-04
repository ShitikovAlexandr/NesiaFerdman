//
//  NFPop.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 7/3/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFPop.h"

@interface NFPop ()

@end

@implementation NFPop

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


+ (void)startAlertWithMassage:(NSString *)massage {
    [NFPop showCardAlertWithTitle:@""
                               message:massage
                              duration:3.f
                           hideOnSwipe:YES
                             hideOnTap:YES
                             alertType:ISAlertTypeSuccess
                         alertPosition:ISAlertPositionTop
                               didHide:^(BOOL finished) {
                                   NSLog(@"Alert did hide.");
                               }];
}

@end
