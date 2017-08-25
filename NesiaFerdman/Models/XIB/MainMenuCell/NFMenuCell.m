//
//  NFMenuCell.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/8/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFMenuCell.h"

@interface  NFMenuCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleItemLabel;
@end

@implementation NFMenuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)addDataToCell:(NFMenuItem*)item {
    self.titleItemLabel.text = item.title;
    [self.iconView setImage:[UIImage imageNamed:item.imageName]];
}

- (void)prepareForReuse {
    self.textLabel.text = @"";
    [self.imageView setImage:nil];
}

@end
