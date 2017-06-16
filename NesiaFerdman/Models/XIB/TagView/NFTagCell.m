//
//  NFTagCell.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 6/1/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFTagCell.h"

@interface NFTagCell ()
@end

@implementation NFTagCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.cancelButton.layer.cornerRadius = self.cancelButton.frame.size.height/2.0;
    self.layer.masksToBounds = true;
    
}


+ (CGSize)calculateSizeWithValue:(NFValue*)value {
    UILabel *label = [[UILabel alloc] init];
    label.text = [value valueForKey:@"valueTitle"];
    [label sizeToFit];
    return CGSizeMake(label.frame.size.width + 60.f, 45.f);
}

- (void)addDataToCell:(NFValue*)value {
    _titleLabel.text = value.valueTitle;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.layer.cornerRadius = self.frame.size.height/2.0;
    self.layer.masksToBounds = true;
    
}


@end
