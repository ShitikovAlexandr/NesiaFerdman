//
//  NFViewController.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 4/13/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFViewController.h"
#import "NotifyList.h"
#import "NFFilterValueControllerViewController.h"
#import "NFEditTaskController.h"

@interface NFViewController ()

@end

@implementation NFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //NFNavigationBar *customNavBar = [[NFNavigationBar alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(navigateToFilterScreen) name:VALUE_FILTER_PRESS object:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:VALUE_FILTER_PRESS object:nil];
}


- (void)addButtonAction {
}

- (void)navigateToFilterScreen {
    NFFilterValueControllerViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NFFilterValueControllerViewController"];
    UINavigationController *navController = [self.storyboard instantiateViewControllerWithIdentifier:@"NFFilterNavigatinController"];
    [navController setViewControllers:@[viewController]];
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)navigateToEditTaskScreenWithEvent:(NFNEvent*)event {
    //NFEditTaskNavController
    
    NFEditTaskController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NFEditTaskController"];
    viewController.event = event;
    UINavigationController *navController = [self.storyboard instantiateViewControllerWithIdentifier:@"NFEditTaskNavController"];
    [navController setViewControllers:@[viewController]];
    [self presentViewController:navController animated:YES completion:nil];
}

//- (void)navigateToGoogleCalendarScreen {
//    
//    NFGoogleCalendarController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NFGoogleCalendarController"];
//    UINavigationController *navController = [self.storyboard instantiateViewControllerWithIdentifier:@"NFGoogleCalendarNav"];
//    [navController setViewControllers:@[viewController]];
//    [self presentViewController:navController animated:YES completion:nil];
//}




@end

