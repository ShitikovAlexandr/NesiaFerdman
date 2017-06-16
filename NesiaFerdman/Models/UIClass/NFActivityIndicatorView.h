//
//  NFActivityIndicatorView.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 6/6/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <DGActivityIndicatorView/DGActivityIndicatorView.h>

@interface NFActivityIndicatorView : DGActivityIndicatorView

- (instancetype)initWithView:(UIView*)view;
- (instancetype)initWithView:(UIView*)view style:(DGActivityIndicatorAnimationType)type;
- (void)endAnimating;

@end
