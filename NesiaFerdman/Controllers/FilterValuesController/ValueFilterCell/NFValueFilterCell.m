//
//  NFValueFilterCell.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 5/31/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFValueFilterCell.h"
#import "NFTaskManager.h"
#import "NFValue.h"

@implementation NFValueFilterCell

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
        
        if ([NFTaskManager sharedManager].selectedValuesArray.count > 0) {
            for (NFValue *val in [NFTaskManager sharedManager].selectedValuesArray) {
                if ([value.valueId isEqualToString:val.valueId]) {
                    [self.valueSwitcer setOn:true animated:true];
                    break;
                }
            }
        }
    }
}

@end
