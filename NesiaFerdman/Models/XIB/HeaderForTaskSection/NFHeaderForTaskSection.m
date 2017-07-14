//
//  NFHeaderForTaskSection.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 5/4/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFHeaderForTaskSection.h"
#import "NFStyleKit.h"

@interface NFHeaderForTaskSection()
@end

@implementation NFHeaderForTaskSection

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        if (self.subviews.count == 0) {
            UINib *nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
            UIView *subview = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
            subview.frame = self.bounds;
            subview.backgroundColor = [NFStyleKit _base_GREY];
            [NFStyleKit drawDownBorderWithView:self];
            self.dayTitle.text = @"";
            self.taskCountLabel.text = @"";
            [self addSubview:subview];
        }
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [NFStyleKit drawDownBorderWithView:self];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        if (self.subviews.count == 0) {
            UINib *nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
            UIView *subview = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
            subview.frame = frame;
            subview.backgroundColor = [NFStyleKit _base_GREY];
            
            CATransition *animation = [CATransition animation];
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            animation.type = kCATransitionPush;
            animation.subtype = kCATransitionFromTop;
            animation.duration = 0.3;
            [self.layer addAnimation:animation forKey:@"kCATransitionReveal"];
            [self addSubview:subview];
            self.taskCountLabel.text = @"";
            [NFStyleKit drawDownBorderWithView:subview];
            [self.iconImage setImage:[UIImage imageNamed:@"List_Document@2x.png"]];
        }
    }
    return self;
}

- (void)setCurrentDate:(NSDate *)date {
    NSString *day = [self stringFromDate:date withFormat:@"dd"];
    NSString *month = [self stringFromDate:date withFormat:@"MMMM"];
    
    self.dayTitle.text = [NSString stringWithFormat:@"%@ %@", day, month.uppercaseString];
}

- (void)setTaskCount:(NSArray *)array {
    _taskCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)array.count];
}

- (NSString *)stringFromDate:(NSDate *)currentDate withFormat:(NSString*)format {
    NFDateFormatter *dateFormatter1 = [[NFDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:format];
    dateFormatter1.locale = [NSLocale localeWithLocaleIdentifier:@"ru_RU"];
    NSString* newDate = [dateFormatter1 stringFromDate:currentDate];
    return newDate;
}

+ (CGFloat)headerSize {

    return 34.0;
}
- (void)layoutSubviews {
    [super layoutSubviews];
}

@end
