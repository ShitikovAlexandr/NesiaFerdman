//
//  NFTaskCellDescription.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 7/28/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFNEvent.h"

@interface NFTaskCellDescription : UITableViewCell
@property (strong, nonatomic) NFNEvent *event;

- (void)addData:(NFNEvent*)event;
+ (CGFloat)cellSize;

@end
