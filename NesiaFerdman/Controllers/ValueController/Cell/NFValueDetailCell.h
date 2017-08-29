//
//  NFValueDetailCell.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/6/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFNManifestation.h"

@interface NFValueDetailCell : UITableViewCell
@property (strong, nonatomic) NFNManifestation *manifestation;

- (void)addDataToCell:(NFNManifestation*)manifestation;

+ (CGFloat)cellSize;

@end
