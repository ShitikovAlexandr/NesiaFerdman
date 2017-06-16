//
//  NFLeftRoundetButton.m
//  DrawTest
//
//  Created by Alex_Shitikov on 5/23/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFLeftRoundetButton.h"
#import "NFStyleKit.h"

@implementation NFLeftRoundetButton


- (void)drawRect:(CGRect)rect {
    
    self.layer.cornerRadius = 8.0f;
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.2;
    self.layer.shadowRadius = 6.0;
    self.layer.shadowOffset = CGSizeMake(-6, 3.0);
    
    //// Color Declarations
    UIColor* blueButtonColor = [UIColor colorWithRed: 0.267 green: 0.29 blue: 0.706 alpha: 1];
    
    //// Rectangle Drawing
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRoundedRect: rect byRoundingCorners: UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii: CGSizeMake(26, 26)];
    [rectanglePath closePath];
    [blueButtonColor setFill];
    [rectanglePath fill];

}

@end
