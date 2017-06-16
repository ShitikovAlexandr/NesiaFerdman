//
//  NFViewWithDownBorder.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 6/15/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFViewWithDownBorder.h"
#import "NFStyleKit.h"

@implementation NFViewWithDownBorder

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    [linePath moveToPoint:CGPointMake(0, rect.size.height)];
    [linePath addLineToPoint:CGPointMake(rect.size.width, rect.size.height)];
    linePath.lineWidth = 1.0;
    [[NFStyleKit _borderDarkGrey] setStroke];
    [linePath stroke];
    
    //    CAShapeLayer *line = [CAShapeLayer layer];
//    line.path =  linePath.CGPath;
//    line.lineWidth =  2.0;
//    line.fillColor = [NFStyleKit _borderDarkGrey].CGColor;
//    [self.layer addSublayer:line];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [NFStyleKit _base_GREY];
//    CGRect sepFrame = CGRectMake(0, self.frame.size.height-1,self.frame.size.width, 1.0);
//    UIView *seperatorView = [[UIView alloc] initWithFrame:sepFrame];
//    seperatorView.backgroundColor = [NFStyleKit _borderDarkGrey];
//    [self addSubview:seperatorView];

}




@end
