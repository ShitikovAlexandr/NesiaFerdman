//
//  NFLogInButton.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/23/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFLogInButton.h"
#import "NFStyleKit.h"

@implementation NFLogInButton
- (void)drawRect:(CGRect)rect {
    
    self.layer.cornerRadius = 8.0f;
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.4;
    self.layer.shadowRadius = 6.0;
    self.layer.shadowOffset = CGSizeMake(0, 4);
    self.tintColor = [UIColor whiteColor];
    
    //// Rectangle Drawing
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRoundedRect: rect cornerRadius: rect.size.height/2.0];
    [NFStyleKit._googleRed setFill];
    [rectanglePath fill];
}

@end
