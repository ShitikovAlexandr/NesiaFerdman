//
//  NFValueDetailCell.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 7/6/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFValueDetailCell.h"

@implementation NFValueDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)addDataToCell:(NFNManifestation*)manifestation {
    
    if (manifestation) {
        self.textLabel.text = manifestation.title;
        self.manifestation = manifestation;
    } else {
        self.textLabel.text = @"Добавить";
        [self.imageView setImage:[UIImage imageNamed:@"Add.png"]];
    }
}

- (void)prepareForReuse {
    self.textLabel.text = @"";
    [self.imageView setImage:nil];
    self.manifestation = nil;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat imageDiametr = 17.f;
    self.imageView.frame = CGRectMake(19, self.imageView.center.y - imageDiametr/2, imageDiametr , imageDiametr);
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

@end
