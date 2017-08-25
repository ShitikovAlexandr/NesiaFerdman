//
//  NFTutorialCell.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/23/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFTutorialCell.h"

@implementation NFTutorialCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imageView.layer.cornerRadius = 8.0;
    
    
}


- (void)addDataToCell:(UIImage*)image {
    [_imageView setImage:image];
}

@end
