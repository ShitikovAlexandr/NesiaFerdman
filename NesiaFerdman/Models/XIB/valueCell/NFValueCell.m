//
//  NFValueCell.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/9/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFValueCell.h"

@implementation NFValueCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)addData:(NFNValue *)value {
    if (value) {
        _valueTitle.text = value.valueTitle;
        if (value.valueImage) {
            [_vaueIcon setImage:[UIImage imageNamed:value.valueImage]];
        } else {
            [_vaueIcon setImage:[UIImage imageNamed:@"defaultValue.png"]];
        }
    }
}

+ (CGFloat)cellSize {
    return 60.0;
}

@end
