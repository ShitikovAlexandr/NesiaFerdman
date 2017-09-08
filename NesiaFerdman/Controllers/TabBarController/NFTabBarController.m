//
//  NFTabBarController.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 9/8/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFTabBarController.h"
#import "NFStatisticPageController.h"

@interface NFTabBarController ()

@end

@implementation NFTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self presentStatistic];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}



- (void)presentStatistic {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *pushData = [defaults objectForKey:PUSH_ACTION_KEY];
    if ([pushData isEqualToString:PUSH_ACTION_VALUE]) {
        [self.presentedViewController dismissViewControllerAnimated:YES completion:^{
                   }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [defaults setValue:@"no" forKey:PUSH_ACTION_KEY];
            NFStatisticPageController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NFStatisticPageController"];
            UINavigationController *navController = [self.storyboard instantiateViewControllerWithIdentifier:@"NFStatisticPageControllerNav"];
            [navController setViewControllers:@[viewController]];
            [self presentViewController:navController animated:YES completion:nil];

        });
    }
}

@end
