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


- (void) addData:(NFNRsult*)event {
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    if (event) {
        self.event = event;
        self.textLabel.text = event.title;
//        if (event.eventType == Event) {
//            if (event.isDone) {
//                [self.imageView setImage:[UIImage imageNamed:@"checked_enable.png"]];
//            } else {
//                [self.imageView setImage:[UIImage imageNamed:@"checked_disable.png"]];
//            }
//        } else {
//            [self.imageView setImage:[UIImage imageNamed:@"point.png"]];
//        }
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
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat imageDiametr = 17.f;
    self.imageView.frame = CGRectMake(19, self.imageView.center.y - imageDiametr/2, imageDiametr , imageDiametr);
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
}


@end
