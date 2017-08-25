//
//  NFActivityIndicatorView.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/6/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFActivityIndicatorView.h"
#import "NFStyleKit.h"

@interface NFActivityIndicatorView ()
@property (strong, nonatomic) UIVisualEffectView *blurEffectView;

@end

@implementation NFActivityIndicatorView

- (instancetype)initWithView:(UIView*)view {
    self = [super initWithType:DGActivityIndicatorAnimationTypeBallPulse
                     tintColor:[NFStyleKit bASE_GREEN]
                          size:60.f];
    if (self) {
        [self loadingEffectWithView:view];
        self.center = CGPointMake(view.center.x, view.center.y - self.size/2);
        [view addSubview:self];
    }
    return self;
}

- (instancetype)initWithView:(UIView*)view style:(DGActivityIndicatorAnimationType)type {
    self = [super initWithType:DGActivityIndicatorAnimationTypeBallPulse
                     tintColor:[NFStyleKit bASE_GREEN]
                          size:60.f];
    if (self) {
        self.center = CGPointMake(view.center.x, CGRectGetMaxY(view.frame) - self.size);
        [view addSubview:self];
    }
    return self;
}

-  (void)startAnimating {
    self.hidden = NO;
    self.blurEffectView.hidden = NO;
    [super startAnimating];
    
}

- (void)endAnimating {
    [self removeFromSuperview];
    [self.blurEffectView removeFromSuperview];
}

-(void)loadingEffectWithView:(UIView *)view {
    // Blur effect
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    _blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    [_blurEffectView setFrame:view.bounds];
    _blurEffectView.alpha = 0.4;
    _blurEffectView.hidden = YES;
    [view addSubview:_blurEffectView];

   }

@end
