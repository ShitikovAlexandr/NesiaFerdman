//
//  NFRoundetView.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 4/11/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NFRoundetView : UIView

@property (strong, nonatomic) UIView *circleView;
@property (strong, nonatomic) UIImageView *logoImage;

- (id)initWithWrame:(CGRect)frame circleRadius:(CGFloat)radius andImageName:(NSString *)imageName;

- (void)elipseOneSideWithInvertIndex: (CGFloat)invertIndex;
- (void)addCircleView;
- (void)addImage:(UIImage *)image;

- (void)setLoginScreenStyleWithImage:(UIImage *)image;


@end
