//
//  NFTaskSimpleCell.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 5/4/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFEvent.h"
#import "NFTableViewCell.h"

@interface NFTaskSimpleCell : NFTableViewCell
@property (weak, nonatomic) UIImage *checkBox;
@property (strong, nonatomic) NFEvent *event;

- (void)addData:(NFEvent*)event;

@end
