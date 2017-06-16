//
//  NFLoginController.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 5/23/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#define HeaderViewStateSplash -20.0
#define HeaderViewStateLogin -self.view.frame.size.height * 0.15
#define HeaderViewStateRegistration -self.view.frame.size.height * 0.28
#define HeaderViewStateForgotPassworn -self.view.frame.size.height * 0.2



#import "NFLoginController.h"
#import "NFRoundView.h"
#import "NFCircleView.h"
#import "NFLogoView.h"
#import "NFLeftRoundetButton.h"
#import "NFRightRoundetButton.h"
#import "NFLogInButton.h"
#import "NFLabel.h"
#import "NFRegisterTextField.h"
#import "NFFirebaseManager.h"

typedef NS_ENUM(NSUInteger, ScreenState)
{
    Splash = 1,
    Login,
    Registration,
    ForgotPassword
};

@interface NFLoginController () <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet NFRoundView *mainView;
@property (strong, nonatomic) NFCircleView *circleView;
@property (strong, nonatomic) UIImageView *logoImage;
@property (strong ,nonatomic) NFLogoView *logoView;
@property (assign, nonatomic) CGFloat heightFactor;
@property (assign, nonatomic) ScreenState screenState;

@property (assign, nonatomic) CGRect circleViewOriginFrame;
@property (assign, nonatomic) CGRect logoViewOriginFrame;
@property (assign, nonatomic) CGRect logoImageOriginFrame;
@property (assign, nonatomic) CGFloat transformVal;

@property (assign ,nonatomic) BOOL isOn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@property (weak, nonatomic) IBOutlet NFLeftRoundetButton *facebookButton;
@property (weak, nonatomic) IBOutlet NFRightRoundetButton *googleButton;

@property (weak, nonatomic) IBOutlet NFLabel *titleLabel;
@property (weak, nonatomic) IBOutlet NFRegisterTextField *emailTextField;
@property (weak, nonatomic) IBOutlet NFRegisterTextField *passwordTextField;
@property (weak, nonatomic) IBOutlet NFRegisterTextField *confirmPasswordTextField;

@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *centerButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet NFLogInButton *LoginBitton;

@property (weak, nonatomic) IBOutlet UIView *loginButtonsView;
@end

@implementation NFLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTopViews];
    
    _screenState = Login;
    [self transformToState:Splash];
    [_LoginBitton addTarget:self action:@selector(loginWithFirebase) forControlEvents:UIControlEventTouchDown];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self transformScreenViewToState:Login];
    });
}

- (IBAction)loginAction:(UIButton *)sender {
    if (_screenState != sender.tag) {
        NSLog(@"tag %ld", (long)sender.tag);
        _screenState = sender.tag;
        [self transformScreenViewToState:sender.tag];
    } else {
        
    }
}

- (void)loginWithFirebase {
    [_emailTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
    [_confirmPasswordTextField resignFirstResponder];
    if (_screenState  == Login) {
        [[NFFirebaseManager sharedManager] sinInWithEmail:_emailTextField.text
                                                 password:_passwordTextField.text];
        
    } else if (_screenState == Registration) {
        [[NFFirebaseManager sharedManager] registratinOfNewUserWithEmail:_emailTextField.text
                                                                password:_passwordTextField.text];
    }
}

- (void)transformToState:(ScreenState)state {
    _emailTextField.placeholder = @"E-mail";
    _passwordTextField.placeholder = @"Пароль";
    _confirmPasswordTextField.placeholder = @"Подтвердить пароль";
    [_leftButton setTitle: @"Забыли пароль?" forState: UIControlStateNormal];
    [_rightButton setTitle: @"Регистрация" forState: UIControlStateNormal];
    [_centerButton setTitle: @"<- У меня уже есть аккаунт" forState: UIControlStateNormal];
    
    switch (state) {
        case Splash:
        {
            _titleLabel.text = @"КОУЧ\nЕЖЕДНЕВНИК";
            _titleLabel.font = [UIFont systemFontOfSize:20.f];
            _topConstraint.constant = HeaderViewStateSplash;
            _emailTextField.userInteractionEnabled = false;
            _emailTextField.alpha = 0;
            _passwordTextField.userInteractionEnabled = false;
            _passwordTextField.alpha = 0;
            _confirmPasswordTextField.userInteractionEnabled = false;
            _confirmPasswordTextField.alpha = 0;
            _transformVal = HeaderViewStateSplash;
            _centerButton.alpha = 0;
            _centerButton.userInteractionEnabled = NO;
            _loginButtonsView.alpha = 0;
            break;
        }
        case Login:
        {
            _titleLabel.text = @"Логин";
             [_LoginBitton setTitle: @"Войти" forState: UIControlStateNormal];
            _titleLabel.font = [UIFont systemFontOfSize:22.f];
            _topConstraint.constant = HeaderViewStateLogin * 1.2;
            _emailTextField.userInteractionEnabled = true;
            _emailTextField.alpha = 1;
            _passwordTextField.userInteractionEnabled = true;
            _passwordTextField.alpha = 1;
            _confirmPasswordTextField.userInteractionEnabled = false;
            _confirmPasswordTextField.alpha = 0;
            _transformVal = HeaderViewStateLogin*0.9;
            _loginButtonsView.alpha = 1;
            _LoginBitton.tag = Login;
            _rightButton.tag = Registration;
            _leftButton.tag = ForgotPassword;
            
            _leftButton.alpha = 1.0;
            _leftButton.userInteractionEnabled = true;
            _rightButton.alpha = 1.0;
            _rightButton.userInteractionEnabled = true;
            _centerButton.alpha = 0;
            _centerButton.userInteractionEnabled = false;
            break;
        }
        case Registration:
        {
            _titleLabel.text = @"Регистрация";
            [_LoginBitton setTitle: @"Регистрация" forState: UIControlStateNormal];
            _topConstraint.constant = HeaderViewStateRegistration* 1.2;
            _emailTextField.userInteractionEnabled = true;
            _emailTextField.alpha = 1;
            _passwordTextField.userInteractionEnabled = true;
            _passwordTextField.alpha = 1;
            _confirmPasswordTextField.userInteractionEnabled = true;
            _confirmPasswordTextField.alpha = 1;
            _transformVal = HeaderViewStateRegistration*0.4;
            _loginButtonsView.alpha = 1;
            _leftButton.alpha = 0;
            _leftButton.userInteractionEnabled = false;
            _rightButton.alpha = 0;
            _rightButton.userInteractionEnabled = false;
            _centerButton.alpha = 1.0;
            _centerButton.userInteractionEnabled = true;
            break;
        }
        case ForgotPassword:
        {
            _topConstraint.constant = HeaderViewStateForgotPassworn * 1.2;
            _emailTextField.userInteractionEnabled = true;
            _emailTextField.alpha = 1;
            _passwordTextField.userInteractionEnabled = false;
            _passwordTextField.alpha = 0;
            _confirmPasswordTextField.userInteractionEnabled = false;
            _confirmPasswordTextField.alpha = 0;
            _transformVal = HeaderViewStateForgotPassworn;
            _loginButtonsView.alpha = 1;
            break;
        }
        default:
        {
            break;
        }
    }
}

- (void)transformScreenViewToState:(ScreenState)state {
    
    CGFloat buttomOffsetCircle = 8.0;
    CGFloat buttomOffsetLogoView = 18.0;
    [UIView animateWithDuration:1.0
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self transformToState:state];
                         CGFloat transformVal = _transformVal/100 ;
                         [self.view layoutIfNeeded];
                         NSLog(@"transformVal %f", transformVal);
                         CGRect newFrameCircle = _circleViewOriginFrame;
                         newFrameCircle.size = CGSizeMake(_circleViewOriginFrame.size.width * transformVal, _circleViewOriginFrame.size.height * transformVal);
                         _circleView.frame = newFrameCircle;
                         _circleView.center = CGPointMake(_mainView.center.x, _mainView.frame.size.height  - _circleView.frame.size.height/2.0 - buttomOffsetCircle);
                         CGRect newFrameLogoView = _logoViewOriginFrame;
                         newFrameLogoView.size =  CGSizeMake(_logoViewOriginFrame.size.width * transformVal, _logoViewOriginFrame.size.width * transformVal);
                         _logoView.frame = newFrameLogoView;
                         _logoView.center = CGPointMake(_mainView.center.x, _mainView.frame.size.height - _logoView.frame.size.height/2.0 - buttomOffsetLogoView);
                         CGRect newFrameLogoImage = _logoImageOriginFrame;
                         newFrameLogoImage.size =  CGSizeMake(_logoImageOriginFrame.size.width * transformVal, _logoImageOriginFrame.size.width * transformVal);
                         _logoImage.frame = newFrameLogoImage;
                         _logoImage.center = _logoView.center;
                     } completion:NULL];
}

- (void)initTopViews {
    
    _heightFactor = 0.45;
    
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
    
    _circleViewOriginFrame = _circleView.frame;
    _logoViewOriginFrame = _logoView.frame;
    _logoImageOriginFrame = _logoImage.frame;
}


@end
