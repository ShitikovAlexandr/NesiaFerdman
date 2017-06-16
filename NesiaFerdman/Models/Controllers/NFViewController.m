//
//  NFViewController.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 4/13/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFViewController.h"
#import "NotifyList.h"
#import "NFTAddImportantTaskTableViewController.h"
#import "NFFilterValueControllerViewController.h"
#import "NFEditTaskController.h"
#import "NFGoogleCalendarController.h"

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

- (void)filterAction {
    NSLog(@"NFViewController filter notify");
    NFTAddImportantTaskTableViewController *addVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NFTAddImportantTaskTableViewController"];
    addVC.eventType = Important;
    UINavigationController *navVCB = [self.storyboard instantiateViewControllerWithIdentifier:@"UINavViewController"];
    navVCB.navigationBar.barStyle = UIBarStyleBlack;
    [navVCB setViewControllers:@[addVC] animated:YES];
    [self presentViewController:navVCB animated:YES completion:nil];
}


- (void)addButtonAction {
    NSLog(@"add button pressed from %@", NSStringFromClass([self class]));
}

- (void)navigateToFilterScreen {
    NFFilterValueControllerViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NFFilterValueControllerViewController"];
    UINavigationController *navController = [self.storyboard instantiateViewControllerWithIdentifier:@"NFFilterNavigatinController"];
    [navController setViewControllers:@[viewController]];
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)navigateToEditTaskScreenWithEvent:(NFEvent*)event {
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

