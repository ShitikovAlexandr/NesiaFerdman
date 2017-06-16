//
//  NFMonthTask.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 4/27/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NFWeekTask.h"

@interface NFMonthTask : NSObject
@property (strong, nonatomic) NSMutableArray <NFWeekTask*> *weeks;
@property (strong, nonatomic) NSString *monthKey;


@end
