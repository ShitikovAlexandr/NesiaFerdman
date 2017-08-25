//
//  NFRightRoundetButton.m
//  DrawTest
//
//  Created by Alex_Shitikov on 8/23/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFRightRoundetButton.h"

@implementation NFRightRoundetButton

- (void)drawRect:(CGRect)rect {
    
    self.layer.cornerRadius = 8.0f;
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.2;
    self.layer.shadowRadius = 6.0;
    self.layer.shadowOffset = CGSizeMake(6, 3.0);
    
    //// Color Declarations
   UIColor* redButtonColor = [UIColor colorWithRed: 0.863 green: 0.271 blue: 0.184 alpha: 1];
    //// Rectangle Drawing
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRoundedRect: rect byRoundingCorners: UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii: CGSizeMake(26, 26)];
    [rectanglePath closePath];
       [redButtonColor setFill];
    [rectanglePath fill];
}


@end
