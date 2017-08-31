//
//  NFResultCell.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/21/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFResultCell.h"

@implementation NFResultCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)addManifestation:(NFNManifestation*)manifestation {
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.textLabel.numberOfLines = 0;
    if (manifestation) {
        self.manifestation = manifestation;
        self.textLabel.text = manifestation.title;
        [self.imageView setImage:[UIImage imageNamed:@"point.png"]];
    }
}

- (void)addData:(NFNRsult*)event {
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    if (event) {
        self.event = event;
        self.textLabel.text = event.title;

        [self.imageView setImage:[UIImage imageNamed:@"point.png"]];

    } else {
        self.textLabel.text = @"Добавить";
        [self.imageView setImage:[UIImage imageNamed:@"Add.png"]];
    }
}

- (void)prepareForReuse {
    self.textLabel.text = @"";
    [self.imageView setImage:nil];
    self.event = nil;
    self.manifestation = nil;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat imageDiametr = 17.f;
    self.imageView.frame = CGRectMake(19, self.imageView.center.y - imageDiametr/2, imageDiametr , imageDiametr);
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
}


@end
