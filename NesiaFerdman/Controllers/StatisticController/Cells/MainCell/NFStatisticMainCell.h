//
//  NFStatisticMainCell.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 6/14/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFValue.h"


@interface NFStatisticMainCell : UITableViewCell
@property (strong, nonatomic) NFValue *value;
@property (assign, nonatomic) NSInteger eventCount;

- (void)addDatatoCellwithDictionary:(NSMutableDictionary*)inputDic indexPath:(NSIndexPath*)indexPath;

@end
