//
//  NFRoundetView.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 4/11/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFRoundetView.h"

@implementation NFRoundetView

- (void)layoutSubviews {
    
    //static dispatch_once_t onceToken;
   // dispatch_once(&onceToken, ^{
        [self.circleView removeFromSuperview];
        [self elipseOneSideWithInvertIndex:0.02];
        [self addCircleView];
        [self addImage:[UIImage imageNamed:@"photo.jpg"]];
   // });
}

- (id)initWithWrame:(CGRect)frame circleRadius:(CGFloat)radius andImageName:(NSString *)imageName {
    self = [super init];
    if (self) {
        self.frame = frame;
        [self elipseOneSideWithInvertIndex:radius];
        [self addCircleView];
        [self addImage:[UIImage imageNamed:imageName]];
    }
    return self;
}

- (void)elipseOneSideWithInvertIndex: (CGFloat)invertIndex {
    self.clipsToBounds = YES;
    CGFloat curveRadius = self.frame.size.width * invertIndex;
    CGFloat invertedRadius = 1.0/curveRadius;
    UIBezierPath *ellipticalPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, self.frame.size.width + 2 * invertedRadius * self.frame.size.width, self.frame.size.height * 0.9)];
    [ellipticalPath applyTransform:CGAffineTransformMakeTranslation(-self.frame.size.width * invertedRadius, 0)];
    UIBezierPath *rectanglePath = [UIBezierPath bezierPathWithRect:self.frame];
    [rectanglePath applyTransform:CGAffineTransformMakeTranslation(0, (-self.frame.size.height * 0.9) * 0.5)];
    [ellipticalPath appendPath:rectanglePath];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.frame;
    maskLayer.path = ellipticalPath.CGPath;
    maskLayer.shadowColor = [UIColor blackColor].CGColor;
    maskLayer.shadowRadius = 10.f;
    maskLayer.shadowOpacity = 0.5;
    maskLayer.shadowOffset = CGSizeMake(0, 10.f);
    self.layer.mask = maskLayer;
}

- (void)addCircleView {
    CGRect circle = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetWidth(self.frame));
    self.circleView  = [[UIView alloc] initWithFrame:circle];
    self.circleView.center = CGPointMake(self.center.x, self.center.y * 0.95);
    self.circleView.layer.cornerRadius = CGRectGetWidth(self.circleView.frame)/2;
    self.circleView.backgroundColor = [UIColor colorWithRed:44/255.0 green:161/255.0 blue:65/255.0 alpha:1];
    self.circleView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.circleView.layer.shadowRadius = 8.f;
    self.circleView.layer.shadowOpacity = 0.2;
    self.circleView.layer.shadowOffset = CGSizeMake(0, 0);
    [self.circleView.layer setShouldRasterize:YES];
    [self addSubview:self.circleView];
}

- (void)addImage:(UIImage *)image {
    CGRect circle = CGRectMake(0, 0, (CGRectGetWidth(self.circleView.frame))*0.8, (CGRectGetWidth(self.circleView.frame))*0.8);
    self.logoImage  = [[UIImageView alloc] initWithFrame:circle];
    self.logoImage.center = CGPointMake(self.circleView.center.x, self.circleView.center.y * 1.1);
    self.logoImage.layer.cornerRadius = CGRectGetWidth(self.logoImage.frame)/2;
    self.logoImage.contentMode = UIViewContentModeScaleAspectFit;
    self.logoImage.backgroundColor = [UIColor colorWithRed:71/255.0 green:174/255.0 blue:92/255.0 alpha:1];
    self.logoImage.layer.masksToBounds = YES;
    [self.logoImage setImage:image];
    [self addSubview:self.logoImage];
    
}

- (void)setLoginScreenStyleWithImage:(UIImage *)image {
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    self.layer.sublayers = nil;
    
}

@end


