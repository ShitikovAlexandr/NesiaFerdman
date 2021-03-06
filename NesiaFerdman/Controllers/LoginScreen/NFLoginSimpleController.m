//
//  NFLoginSimpleController.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 6/6/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFLoginSimpleController.h"
#import "NFRoundView.h"
#import "NFCircleView.h"
#import "NFLogoView.h"
#import "NFGoogleManager.h"
#import "NFStyleKit.h"
#import "NotifyList.h"
#import "NFSyncManager.h"
#import "NFActivityIndicatorView.h"

#define TRANSFORM_VALUE -self.view.frame.size.height * 0.12

typedef NS_ENUM(NSUInteger, ScreenState)
{
    Splash = 1,
    Login,
};

@interface NFLoginSimpleController ()
@property (weak, nonatomic) IBOutlet NFRoundView *mainView;
@property (weak, nonatomic) IBOutlet UILabel *socialText;
@property (strong, nonatomic) NFCircleView *circleView;
@property (strong, nonatomic) UIImageView *logoImage;
@property (strong ,nonatomic) NFLogoView *logoView;
@property (assign, nonatomic) CGFloat heightFactor;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstrain;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (strong, nonatomic) NFActivityIndicatorView *indicator;


@end

static NFLoginSimpleController *sharedController;

@implementation NFLoginSimpleController

- (void)viewDidLoad {
    [super viewDidLoad];
    sharedController = self;
    [self initViews];
    [_loginButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchDown];
    

    

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endLoadData) name:END_UPDATE_DATA object:nil];
    [self chackLoginState];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:END_UPDATE_DATA object:nil];
}

+ (NFLoginSimpleController *)sharedMenuController {
    return sharedController;
}

- (void)initViews {
    
    _heightFactor = 0.42;
    
    _mainView.backgroundColor = [UIColor whiteColor];
    [self.view layoutIfNeeded];
    
    CGRect circleFrame = CGRectMake(0, 0, CGRectGetWidth(_mainView.frame) * 0.9, CGRectGetWidth(_mainView.frame) * 0.9);
    _circleView = [[NFCircleView alloc]  initWithFrame:circleFrame];
    _circleView.center = CGPointMake(_mainView.center.x, _mainView.frame.size.height - _circleView.frame.size.height/2 - 4.0);
    _circleView.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:_circleView];
    
    CGRect logoFrame = CGRectMake(0, 0, CGRectGetWidth(_circleView.frame) * 0.7, CGRectGetWidth(_circleView.frame) * 0.7);
    _logoView = [[NFLogoView alloc]  initWithFrame:logoFrame];
    _logoView.center = CGPointMake(_circleView.center.x, _mainView.frame.size.height - _logoView.frame.size.height/2 - 18.0);
    _logoView.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:_logoView];
    
    _logoImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_logoView.frame) * 0.75, CGRectGetWidth(_logoView.frame) * 0.75)];
    _logoImage.backgroundColor  = [UIColor clearColor];
    [_logoImage setImage:[UIImage imageNamed:@"main_logo.png"]];
    _logoImage.center = _logoView.center;
    [self.mainView addSubview:_logoImage];
    
//    _circleViewOriginFrame = _circleView.frame;
//    _logoViewOriginFrame = _logoView.frame;
//    _logoImageOriginFrame = _logoImage.frame;
    _titleLable.text = @"КОУЧ\nЕЖЕДНЕВНИК";
    _socialText.text = @"Вход\nчерез социальную сеть";
    _socialText.tintColor = [NFStyleKit _base_GREY];
    [_loginButton setTitle: @"Google" forState: UIControlStateNormal];
    _loginButton.userInteractionEnabled  = false;
    self.buttonView.alpha = 0;
    
    _indicator = [[NFActivityIndicatorView alloc] initWithView:self.view style:DGActivityIndicatorAnimationTypeBallClipRotateMultiple];
}



- (void) transformToLogin {
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
    
    if ([[NFGoogleManager sharedManager] isLoginWithTarget:self] ) {
        NSLog(@"not login");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self transformToLogin];
        });

    } else {
        NSLog(@"login");
        _loginButton.userInteractionEnabled = false;
        _loginButton.alpha = 0;
        [_indicator startAnimating];
        
        if ([[NFSyncManager sharedManager] isFirstRunApp]) {
            [[NFSyncManager sharedManager] addStandartListOfValue];
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [[NFSyncManager sharedManager] updateAllData];
        });
       
    }
    
}

- (void)loginAction {
    [[NFGoogleManager sharedManager] loginWithGoogleWithTarget:self];
}

- (void)logout {
    [[NFGoogleManager sharedManager] logOutWithTarget:self];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)endLoadData {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_indicator endAnimating];
        [self performSegueWithIdentifier:@"QuoteSegue" sender:nil];
    });

}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
@end
