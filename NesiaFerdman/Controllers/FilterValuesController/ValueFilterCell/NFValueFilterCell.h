//
//  NFValueFilterCell.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 5/31/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFValue.h"

@interface NFValueFilterCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UISwitch *valueSwitcer;
@property (weak, nonatomic) IBOutlet UILabel *valueTitle;
@property (weak, nonatomic) IBOutlet UIImageView *vaueIcon;

- (void)addData:(NFValue *)value;

@end
