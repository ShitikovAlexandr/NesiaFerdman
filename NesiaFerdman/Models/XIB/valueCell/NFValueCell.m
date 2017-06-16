//
//  NFValueCell.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 6/9/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFValueCell.h"

@implementation NFValueCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)addData:(NFValue *)value {
    if (value) {
        _valueTitle.text = value.valueTitle;
        if (value.valueImage) {
            [_vaueIcon setImage:[UIImage imageNamed:value.valueImage]];
        } else {
            [_vaueIcon setImage:[UIImage imageNamed:@"response-value45.png"]];
        }
    }
}
@end
