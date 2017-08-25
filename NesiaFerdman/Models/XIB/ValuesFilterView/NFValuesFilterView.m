//
//  NFValuesFilterView.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/29/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFValuesFilterView.h"
#import "NFStyleKit.h"
#import "NotifyList.h"
#import "NFValuesFilterView.h"
#import "NFValue.h"

@interface NFValuesFilterView ()
@property (weak, nonatomic) IBOutlet NFFilterLabel *titleLabel;
@property (strong, nonatomic) NSMutableArray *valuesArray;

@end

@implementation NFValuesFilterView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    //    [NFStyleKit drawDownBorderWithFrame:self];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
    UIView *subview = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
    subview.frame = self.bounds;
    subview.backgroundColor = [NFStyleKit _lightGrey];
    [self addSubview:subview];
    self.valuesArray = [NSMutableArray array];
    self.titleLabel.backgroundColor = [NFStyleKit _base_GREY];
    self.titleLabel.layer.borderWidth = 1.f;
    self.titleLabel.layer.cornerRadius = 6.f;
    self.titleLabel.layer.borderColor = [NFStyleKit _borderDarkGrey].CGColor;
    self.titleLabel.layer.masksToBounds = true;
    
    self.userInteractionEnabled = true;
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTappedOnLink)];
    [self addGestureRecognizer:gesture];
}

- (void)updateTitleFromArray:(NSArray *)array {
    NSString* title;
    if (array.count > 0) {
        title = [[array valueForKey:@"valueTitle"] componentsJoinedByString:@", "];
    } else {
        title = @"Все ценности";
    }
    _titleLabel.text = title;
}

- (void) userTappedOnLink {
    NSNotification *notification = [NSNotification notificationWithName:VALUE_FILTER_PRESS object:self];
    [[NSNotificationCenter defaultCenter]postNotification:notification];
    NSLog(@"tap");
}

@end
