//
//  NFLoginSimpleDataSource.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/25/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFLoginSimpleDataSource.h"
#import "NFGoogleSyncManager.h"
#import "NFNSyncManager.h"
#import "NFDataSourceManager.h"
#import "NFSettingManager.h"
#import "NFValueController.h"
#import "NFTutorialController.h"
#import "NFQuoteDayViewController.h"
#import "NFCalendarListController.h"
#import "NFAboutValueInfoController.h"

@interface NFLoginSimpleDataSource ()
@property (strong, nonatomic) NFLoginSimpleController *target;
@end

@implementation NFLoginSimpleDataSource

- (instancetype)initWithTarget:(NFLoginSimpleController*)target {
    self = [super init];
    if (self) {
        _target = target;
    }
    return self;
}

- (void)navigateToTutorial {
    //4
    NFQuoteDayViewController *quoteController = [_target.storyboard instantiateViewControllerWithIdentifier:@"NFQuoteDayViewController"];
    
    //3
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
                                @"NewMain" bundle:[NSBundle mainBundle]];
    NFValueController *valueController = [_target.storyboard instantiateViewControllerWithIdentifier:@"NFValueController"];
    valueController.nextController = quoteController;
    valueController.isFirstRun = true;
    valueController.screenState = FirstRunValue;
    //2
    
    NFCalendarListController *calendarListController = [storyboard instantiateViewControllerWithIdentifier:@"NFCalendarListController"];
    calendarListController.isFirstRun = true;
    calendarListController.nextController = valueController;
    //1
    
    NFTutorialController *viewController = [_target.storyboard instantiateViewControllerWithIdentifier:@"NFTutorialController"];
    viewController.isFirstRun = true;
    viewController.nextController = calendarListController;
    
    //    UINavigationController *navController = [_target.storyboard instantiateViewControllerWithIdentifier:@"NFTutorialControllerNav"];
    //    [navController setViewControllers:@[viewController]];
    //    [_target presentViewController:navController animated:YES completion:nil];
    
    //0
    NFAboutValueInfoController *aboutValueController = [storyboard instantiateViewControllerWithIdentifier:@"NFAboutValueInfoController"];
    aboutValueController.nextController = viewController;
    
    UINavigationController *navController = [storyboard instantiateViewControllerWithIdentifier:@"NFAboutValueInfoControllerNav"];
    [navController setViewControllers:@[aboutValueController]];
    [_target presentViewController:navController animated:YES completion:nil];
    
    
}


@end
