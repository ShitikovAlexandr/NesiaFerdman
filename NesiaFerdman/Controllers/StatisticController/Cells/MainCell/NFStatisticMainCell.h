//
//  NFStatisticMainCell.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/14/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFNValue.h"


@interface NFStatisticMainCell : UITableViewCell
@property (strong, nonatomic) NFNValue *value;
@property (assign, nonatomic) NSInteger eventCount;

- (void)addDatatoCellwithDictionary:(NSMutableDictionary*)inputDic indexPath:(NSIndexPath*)indexPath;

@end
