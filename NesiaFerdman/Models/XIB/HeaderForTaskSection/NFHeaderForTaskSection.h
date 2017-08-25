//
//  NFHeaderForTaskSection.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/4/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NFHeaderForTaskSection : UIView
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *dayTitle;
@property (weak, nonatomic) IBOutlet UILabel *taskCountLabel;

- (void)setCurrentDate:(NSDate *)date;
- (void)setTaskCount:(NSArray *)array;

+ (CGFloat)headerSize;

@end
