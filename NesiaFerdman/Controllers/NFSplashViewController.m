//
//  NFSplashViewController.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 4/11/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFSplashViewController.h"
#import "NFRoundButton.h"
#import "NFRoundetView.h"
#import "NFGoogleManager.h"
#import "NFQuoteDayViewController.h"
#import "NFConstants.h"

@interface NFSplashViewController ()
@property (weak, nonatomic) IBOutlet NFRoundButton *continueButton;
@property (weak, nonatomic) IBOutlet NFRoundetView *mainCircleView;
@property (weak, nonatomic) IBOutlet UIImageView *logoView;
@property (weak, nonatomic) IBOutlet UILabel *enterFromSocialLabel;
@property (assign, nonatomic) BOOL nextButtonIsPressed;
@end

@implementation NFSplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.enterFromSocialLabel.hidden = YES;
    [self.continueButton addTarget:self action:@selector(clickNextAction) forControlEvents:UIControlEventTouchDown];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self chackLoginAndSignIn];
}

- (void)clickNextAction {
    [UIView animateWithDuration:0.6
                     animations:^{
                         if (!self.nextButtonIsPressed) {
                             self.nextButtonIsPressed = YES;
                             [self.continueButton setLoginGoogleButtonStyle];
                             [self.logoView setTransform:CGAffineTransformMakeScale(0.7, 0.7)];
                             [self.mainCircleView setTransform:CGAffineTransformMakeTranslation(0, -15.f)];
                             self.logoView.center = CGPointMake(self.logoView.center.x, self.logoView.center.y * 0.9);
                             NSString *socialText = [NSString stringWithFormat:@"Вход%@через социальную сеть", @"\n"];
                             self.enterFromSocialLabel.hidden = NO;
                             self.enterFromSocialLabel.text = socialText;
                             [self.continueButton addTarget:self action:@selector(chackLoginAndSignIn) forControlEvents:UIControlEventTouchDown];
                             self.mainCircleView.circleView.alpha = 0;
                         }
                     }];
}

- (void)chackLoginAndSignIn {
    self.continueButton.hidden = YES;
    if ([[NFGoogleManager sharedManager] isLoginWithTarget:self] ) {
        NSLog(@"not login");
        self.continueButton.hidden = NO;
        if (self.nextButtonIsPressed) {
            [[NFGoogleManager sharedManager] loginWithGoogleWithTarget:self];
        }
    } else {
        NSLog(@" login");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self performSegueWithIdentifier:@"QuoteSegue" sender:nil];
        });
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
