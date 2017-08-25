//
//  NFCalendarListController.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/18/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFViewController.h"
#import "NFActivityIndicatorView.h"


@interface NFCalendarListController : NFViewController

@property (assign, nonatomic) BOOL isFirstRun;
@property (assign, nonatomic) BOOL isCompliteDownload;
@property (strong, nonatomic) UIViewController *nextController;
@property (strong, nonatomic) NFActivityIndicatorView *indicator;


@end
