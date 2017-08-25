//
//  NFHeaderDayOfWeek.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/3/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NFHeaderDayOfWeek : UIView
@property (strong, nonatomic) UILabel *dayName;
@property (strong, nonatomic) UILabel *dayValue;

- (void)setDate:(NSDate*)date;

@end
