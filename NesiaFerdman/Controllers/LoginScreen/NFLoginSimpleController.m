//
//  NFLoginSimpleController.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/6/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFLoginSimpleController.h"
#import "NFRoundView.h"
#import "NFStyleKit.h"
#import "NotifyList.h"
#import "NFActivityIndicatorView.h"
#import "NFCalendarListController.h"
#import "NFGoogleSyncManager.h"
#import "NFNSyncManager.h"
#import "NFDataSourceManager.h"
#import "NFSettingManager.h"
#import "NFValueController.h"
#import "NFTutorialController.h"
#import "NFQuoteDayViewController.h"

#import "NFLoginSimpleDataSource.h"

@import Firebase;

#define TRANSFORM_VALUE -self.view.frame.size.height * 0.08
#define kNFLoginSimpleControllerSocialTitle @"Вход через учетную запись"

typedef NS_ENUM(NSUInteger, ScreenState)
{
    Splash = 1,
    Login,
};

@interface NFLoginSimpleController ()
@property (weak, nonatomic) IBOutlet NFRoundView *mainView;
@property (weak, nonatomic) IBOutlet UILabel *socialText;
@property (strong, nonatomic) UIImageView *logoImage;
@property (assign, nonatomic) CGFloat heightFactor;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstrain;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (strong, nonatomic) NFActivityIndicatorView *indicator;
@property (assign, nonatomic) BOOL isFirstRun;
@property (assign, nonatomic) BOOL isUpdate;
@property (assign, nonatomic) BOOL isSelectCalendars;

@property (strong, nonatomic) NFLoginSimpleDataSource *dataSource;

@end

static NFLoginSimpleController *sharedController;

@implementation NFLoginSimpleController

- (void)viewDidLoad {
    [super viewDidLoad];
    sharedController = self;
    [self initLoginImageView];
    [_loginButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchDown];
}

- (void)viewWillAppear:(BOOL)animated {
    _dataSource = [[NFLoginSimpleDataSource alloc] initWithTarget:self];
    [super viewWillAppear:animated];
    [self startIndicator];
    _loginButton.userInteractionEnabled = false;
    _loginButton.alpha = 0;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self chackLoginState];
    });
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

+ (NFLoginSimpleController *)sharedMenuController {
    return sharedController;
}

- (void) transformToLogin {
    [_indicator endAnimating];
    _topConstrain.constant = TRANSFORM_VALUE;
    [UIView animateWithDuration:1.0
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{_loginButton.userInteractionEnabled = true;
                         _loginButton.alpha = 1;
                         _buttonView.alpha = 1.0;
                         _loginButton.userInteractionEnabled = true;
                         [self.view layoutIfNeeded];
                     }
                     completion:NULL];
}

- (void)chackLoginState {
      if (![[NFGoogleSyncManager sharedManager] isLogin]) {
        NSLog(@"not login");
        [[NFGoogleSyncManager sharedManager] logOutAction];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self transformToLogin];
        });
    } else {
        NSLog(@"login");
        [_indicator startAnimating];
        _loginButton.userInteractionEnabled = false;
        _loginButton.alpha = 0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([[NFNSyncManager sharedManager] isFirstRunApp]) {
                [NFSettingManager setOnGoogleSync];
                [NFSettingManager setOnWriteToGoogle];
                [NFSettingManager setOnDeleteFromGoogle];
                [_dataSource navigateToTutorial];
            } else if ([[NFNSyncManager sharedManager] isFirstRunToday] && ![[NFNSyncManager sharedManager] isFirstRunApp]) {
                
                
                [self performSegueWithIdentifier:@"QuoteSegue" sender:nil];
            } else {
                [_dataSource navigateToTutorial];
                //[self performSegueWithIdentifier:@"TaskSegue" sender:nil];
            }
        });
    }
}

- (void)loginAction {
    _loginButton.alpha = 0;
    _loginButton.userInteractionEnabled = false;
    [[NFGoogleSyncManager sharedManager] loginActionWithTarget:self];
}

- (void)logout {
    [[NFGoogleSyncManager sharedManager] logOutAction];
    [self transformToLogin];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)initLoginImageView {
    _socialText.text = kNFLoginSimpleControllerSocialTitle;
    _socialText.tintColor = [NFStyleKit _base_GREY];
    [_loginButton setImage:[UIImage imageNamed:@"google_icon"] forState:UIControlStateNormal];
    [_loginButton setTitle: @"Google +" forState: UIControlStateNormal];
    _loginButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
    _loginButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    _loginButton.userInteractionEnabled  = false;
    self.buttonView.alpha = 0;
    _indicator = [[NFActivityIndicatorView alloc] initWithView:self.view style:DGActivityIndicatorAnimationTypeBallClipRotateMultiple];
}

//- (void)navigateToTutorial {
//    //4
//    NFQuoteDayViewController *quoteController = [self.storyboard instantiateViewControllerWithIdentifier:@"NFQuoteDayViewController"];
//    
//    //3
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
//                                @"NewMain" bundle:[NSBundle mainBundle]];
//    NFValueController *valueController = [self.storyboard instantiateViewControllerWithIdentifier:@"NFValueController"];
//    valueController.nextController = quoteController;
//    valueController.isFirstRun = true;
//    valueController.screenState = FirstRunValue;
//    //2
//    
//    NFCalendarListController *calendarListController = [storyboard instantiateViewControllerWithIdentifier:@"NFCalendarListController"];
//    calendarListController.isFirstRun = true;
//    calendarListController.nextController = valueController;
//    //1
//    
//    NFTutorialController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NFTutorialController"];
//    viewController.isFirstRun = true;
//    viewController.nextController = calendarListController;
//    
//    UINavigationController *navController = [self.storyboard instantiateViewControllerWithIdentifier:@"NFTutorialControllerNav"];
//    [navController setViewControllers:@[viewController]];
//    [self presentViewController:navController animated:YES completion:nil];
//}

- (void)startIndicator {
    _indicator = [[NFActivityIndicatorView alloc] initWithView:self.view style:DGActivityIndicatorAnimationTypeBallClipRotateMultiple];
    [_indicator startAnimating];
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
@end
