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
//    _imageView.layer.shadowColor = [UIColor blackColor].CGColor;
//    _imageView.layer.shadowRadius = 8.0;
//    _imageView.layer.shadowOffset = CGSizeMake(0, 2);
//    _imageView.layer.masksToBounds = NO;
//    _imageView.layer.shadowOpacity = 0.7;
}


- (void)addDataToCell:(NFTutorialItem*)item  {
    [_imageView setImage:[UIImage imageNamed:item.imageName]];
    _infoLabel.text = item.title;
    _descriptionLabel.text = item.text;
    
}

- (UIImage*)imageWithShadowForImage:(UIImage *)initialImage {
    
    CGColorSpaceRef colourSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef shadowContext = CGBitmapContextCreate(NULL, initialImage.size.width + 80, initialImage.size.height + 80, CGImageGetBitsPerComponent(initialImage.CGImage), 0, colourSpace, kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colourSpace);
    
    CGContextSetShadowWithColor(shadowContext, CGSizeMake(0,0), 40, [UIColor blackColor].CGColor);
    CGContextDrawImage(shadowContext, CGRectMake(40, 40, initialImage.size.width, initialImage.size.height), initialImage.CGImage);
    
    CGImageRef shadowedCGImage = CGBitmapContextCreateImage(shadowContext);
    CGContextRelease(shadowContext);
    
    UIImage * shadowedImage = [UIImage imageWithCGImage:shadowedCGImage];
    CGImageRelease(shadowedCGImage);
    return shadowedImage;
}
@end
