//
//  NFHourTask.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/27/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NFEvent.h"

@interface NFHourTask : NSObject

@property (strong, nonatomic) NSMutableArray <NFEvent*> *events;

@end
