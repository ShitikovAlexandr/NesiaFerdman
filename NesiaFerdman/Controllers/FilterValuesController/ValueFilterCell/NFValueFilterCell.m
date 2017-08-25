//
//  NFValueFilterCell.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/31/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFValueFilterCell.h"
#import "NFDataSourceManager.h"
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

- (void)addData:(NFNValue *)value {
    if (value) {
        _valueTitle.text = value.valueTitle;
        if (value.valueImage) {
            [_vaueIcon setImage:[UIImage imageNamed:value.valueImage]];
        } else {
           [_vaueIcon setImage:[UIImage imageNamed:@"defaultValue.png"]];
        }
        
        if ([[NFDataSourceManager sharedManager] getSelectedValueList].count > 0) {
            for (NFNValue *val in [[NFDataSourceManager sharedManager] getSelectedValueList]) {
                if ([value.valueId isEqualToString:val.valueId]) {
                    [self.valueSwitcer setOn:true animated:true];
                    break;
                }
            }
        }
    }
}

@end
