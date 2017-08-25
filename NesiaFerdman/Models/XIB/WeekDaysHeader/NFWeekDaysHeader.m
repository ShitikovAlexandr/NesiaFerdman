//
//  NFWeekDaysHeader.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/3/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFWeekDaysHeader.h"

@implementation NFWeekDaysHeader


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CALayer *downBorder = [CALayer layer];
    downBorder.backgroundColor = [UIColor colorWithRed:238/255.0 green:239/255.0 blue:241/255.0 alpha:1].CGColor;
    downBorder.frame = CGRectMake(0, rect.size.height - 1.0, CGRectGetWidth(self.frame), 1.0);
    [self.layer addSublayer:downBorder];
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        if (self.subviews.count == 0) {
            UINib *nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
            UIView *subview = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
            subview.frame = self.bounds;
            [self addSubview:subview];
        }
    }
    return self;
}



@end
