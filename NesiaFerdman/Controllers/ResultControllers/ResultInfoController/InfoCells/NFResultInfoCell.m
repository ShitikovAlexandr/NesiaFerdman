//
//  NFResultInfoCell.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 10/2/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFResultInfoCell.h"

@interface NFResultInfoCell ()
@property (strong, nonatomic) NFResultInfoItem *item;
@end

@implementation NFResultInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)addDataToCell:(NFResultInfoItem*)item {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.textLabel.numberOfLines = 0;
    self.textLabel.text = item.title;
    self.item = item;
    
    if (item.isBold) {
        self.textLabel.font = [UIFont boldSystemFontOfSize:17.0];
    }
    
    if (item.inList) {
        [self.imageView setImage:[UIImage imageNamed:@"point.png"]];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.item.inList) {
        CGFloat imageDiametr = 14.f;
        self.imageView.frame = CGRectMake(14.0, 16.0, imageDiametr , imageDiametr);
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        CGRect textLabelFrame = self.textLabel.frame;
        textLabelFrame.origin.x = 40.0;
        self.textLabel.frame = textLabelFrame;
    }
}

- (void)prepareForReuse {
    self.item = nil;
    self.textLabel.text = @"";
    self.textLabel.font = [UIFont systemFontOfSize:17.0];
    [self.imageView setImage:nil];

}


@end
