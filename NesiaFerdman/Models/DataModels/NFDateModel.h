//
//  NFDateModel.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/20/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NFDateModel : NSObject

@property (strong, nonatomic) NSDate *currentDate;
@property (strong, nonatomic) NSString *currentDateString;
@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;
@property (strong, nonatomic) NSMutableArray *fromToDateArray;
@property (strong, nonatomic) NSMutableArray *weekArray;

- (instancetype)initWithStartDate:(NSDate *)start endDate:(NSDate *)end;

@end
