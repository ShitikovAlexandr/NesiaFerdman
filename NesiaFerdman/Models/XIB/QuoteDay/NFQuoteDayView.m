//
//  NFQuoteDayView.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 4/11/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFQuoteDayView.h"

@implementation NFQuoteDayView
-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        if (self.subviews.count == 0) {
//            UINib *nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
//            UIView *subview = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
//            subview.frame = self.bounds;
//            [self addSubview:subview];
//            
//            CGFloat cornerRadius = 12.f;
//            self.mainView.layer.cornerRadius = cornerRadius;
//            self.secondView.layer.cornerRadius = cornerRadius;
//            self.lastView.layer.cornerRadius = cornerRadius;
//            
//            self.mainView.layer.shadowColor = [UIColor blackColor].CGColor;
//            self.mainView.layer.shadowOffset = CGSizeMake(0.f, 4.f);
//            self.mainView.layer.shadowRadius = 4.0f;
//            self.mainView.layer.shadowOpacity = 0.2;
            
            //set current date
            NSDateFormatter *dateFormatterDay = [[NSDateFormatter alloc] init];
            [dateFormatterDay setDateFormat:@"dd"];
            NSString* day = [dateFormatterDay stringFromDate:[NSDate date]];
            
            NSDateFormatter *dateFormatterMonth = [[NSDateFormatter alloc] init];
            [dateFormatterMonth setDateFormat:@"MMMM"];
            NSString* month = [dateFormatterMonth stringFromDate:[NSDate date]];
            
            self.dayLabel.text = day;
            self.monthLabel.text = month;
        }
    }
    return self;
}
@end


