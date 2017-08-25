//
//  NFQuoteDayView.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/11/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFQuoteDayView.h"

@implementation NFQuoteDayView
-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        if (self.subviews.count == 0) {
            
            //set current date
            NFDateFormatter *dateFormatterDay = [[NFDateFormatter alloc] init];
            [dateFormatterDay setDateFormat:@"dd"];
            NSString* day = [dateFormatterDay stringFromDate:[NSDate date]];
            
            NFDateFormatter *dateFormatterMonth = [[NFDateFormatter alloc] init];
            [dateFormatterMonth setDateFormat:@"MMMM"];
            NSString* month = [dateFormatterMonth stringFromDate:[NSDate date]];
            
            self.dayLabel.text = day;
            self.monthLabel.text = month;
        }
    }
    return self;
}
@end


