//
//  NFValueCell.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/9/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFValueCell.h"


@interface NFValueCell()
@property (weak, nonatomic) NFNValue *value;
@end

@implementation NFValueCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //self.selectionStyle = UITableViewCellSelectionStyleNone;
    //self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)addData:(NFNValue *)value {
    if (value) {
        _pressAction.selected = !value.isDeleted;
        _value = value;
        _valueTitle.text = value.valueTitle;
        [_vaueIcon setImage:[UIImage imageNamed:@"defaultValue.png"]];
    } else {
        NSLog(@"no value in cell");
    }
}

- (IBAction)pressButtonAction:(UIButton *)sender {
    _value.isDeleted = !_value.isDeleted;
    NSLog(@"cell action is %@", @(_value.isDeleted));
}

+ (CGFloat)cellSize {
    return 60.0;
}

- (void)prepareForReuse {
    _value = nil;
}

@end
