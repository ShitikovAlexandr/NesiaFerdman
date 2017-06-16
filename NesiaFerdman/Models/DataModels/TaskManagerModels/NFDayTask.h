//
//  NFDayTask.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 4/27/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NFHourTask.h"

@interface NFDayTask : NSObject
@property (strong ,nonatomic) NSMutableArray <NFHourTask*> *days;
@property (strong, nonatomic) NSString *dayKey;

@end
