//
//  NFResultCell.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/21/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFNRsult.h"
#import "NFNManifestation.h"

@interface NFResultCell : UITableViewCell
@property (strong, nonatomic) NFNRsult *event;
@property (strong, nonatomic) NFNManifestation *manifestation;

- (void)addData:(NFNRsult*)event;
- (void)addManifestation:(NFNManifestation*)manifestation;

@end
