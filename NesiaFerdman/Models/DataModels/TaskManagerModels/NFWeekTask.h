//
//  NFWeekTask.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/27/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NFDayTask.h"

@interface NFWeekTask : NSObject
@property (strong, nonatomic) NSMutableArray <NFDayTask*> *days;
@property (strong, nonatomic) NSString *weekKey;


@end
