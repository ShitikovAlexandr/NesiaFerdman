//
//  NFProgressView.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/14/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFProgressShapeLayer.h"

@interface NFProgressView : UIView

@property (strong, nonatomic) NFProgressShapeLayer *progressLayer;
@property (strong, nonatomic) UIColor *progressColor;

@end
