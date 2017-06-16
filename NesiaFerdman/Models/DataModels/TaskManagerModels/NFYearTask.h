//
//  NFYearTask.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 4/27/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NFMonthTask.h"

@interface NFYearTask : NSObject
@property (strong, nonatomic) NSMutableArray <NFMonthTask*> *months;
@property (strong, nonatomic) NSString *monthKey;



@end
