//
//  NFPop.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 7/3/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFPop.h"


static BOOL isShowAlert = false;

@interface NFPop ()
@property (assign, nonatomic) BOOL isShowAlert;
@end

@implementation NFPop

@synthesize isShowAlert;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


+ (void)startAlertWithMassage:(NSString *)massage {
    
    if (!isShowAlert) {
        isShowAlert = true;
    [NFPop showCardAlertWithTitle:@""
                               message:massage
                              duration:3.f
                           hideOnSwipe:YES
                             hideOnTap:YES
                             alertType:ISAlertTypeError
                         alertPosition:ISAlertPositionTop
                               didHide:^(BOOL finished) {
                                   NSLog(@"Alert did hide.");
                                   isShowAlert = false;
                               }];
    }

}

+ (void)internetConnectionAlert {
    if (!isShowAlert) {
        isShowAlert = true;
        [NFPop showCardAlertWithTitle:@""
                              message:kErrorInternetconnection
                             duration:3.f
                          hideOnSwipe:YES
                            hideOnTap:YES
                            alertType:ISAlertTypeWarning
                        alertPosition:ISAlertPositionTop
                              didHide:^(BOOL finished) {
                                  NSLog(@"Alert did hide.");
                                  isShowAlert = false;
                              }];
    }

}

@end
