//
//  NFTagCell.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/1/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFTagCell.h"

@interface NFTagCell ()
@end

@implementation NFTagCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.cancelButton.layer.cornerRadius = self.cancelButton.frame.size.height/2.0;
    self.cancelButton.userInteractionEnabled = false;
    self.layer.masksToBounds = true;
    
    
}


+ (CGSize)calculateSizeWithValue:(NFNValue*)value isEditMode:(BOOL)editMode {
    UILabel *label = [[UILabel alloc] init];
    label.text = [value valueForKey:@"valueTitle"];
    [label sizeToFit];
    if (editMode) {
        return CGSizeMake(label.frame.size.width + 60.f, 45.f);
    } else {
        return CGSizeMake(label.frame.size.width + 25.f, 45.f);
    }
    
}

- (void)addDataToCell:(NFNValue*)value isEditMode:(BOOL)editMode {
    _titleLabel.text = [value valueForKey:@"valueTitle"];
    if (editMode) {
        self.cancelButton.hidden = NO;
    } else {
        self.cancelButton.hidden = YES;

    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.layer.cornerRadius = self.frame.size.height/2.0;
    self.layer.masksToBounds = true;
    
}


@end
