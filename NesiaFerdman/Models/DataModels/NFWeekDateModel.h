//
//  NFWeekDateModel.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 4/20/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NFWeekDateModel : NSObject
@property (strong, nonatomic) NSDate *startOfWeek;
@property (strong, nonatomic) NSDate *endOfWeek;
@property (strong, nonatomic) NSMutableArray *allDateOfWeek;
@property (strong, nonatomic) NSDate *startDate;


- (void)getDescription;

@end
