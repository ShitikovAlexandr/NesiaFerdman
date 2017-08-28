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
 
    
}


- (void)addDataToCell:(UIImage*)image index:(NSInteger)index {
    [_imageView setImage:[self imageWithShadowForImage:image]];
    _infoLabel.text = [NSString stringWithFormat:@"Test text #%ld", (long)index+1];
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
