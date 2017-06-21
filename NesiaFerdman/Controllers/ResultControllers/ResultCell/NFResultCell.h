//
//  NFResultCell.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 6/21/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFResult.h"

@interface NFResultCell : UITableViewCell
@property (strong, nonatomic) NFResult *event;

- (void) addData:(NFResult*)event;

@end
