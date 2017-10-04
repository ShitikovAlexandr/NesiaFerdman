//
//  NFTutorialCell.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/23/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFTutorialCell.h"
#import "NFStyleKit.h"

@implementation NFTutorialCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.stepCountLabel.textColor = [NFStyleKit bASE_GREEN];
    
}


- (void)addDataToCell:(NFTutorialItem*)item number:(NSInteger)numper  {
    self.stepCountLabel.text = [NSString stringWithFormat:@"Шаг %ld", numper + 1];
    [_imageView setImage:[UIImage imageNamed:item.imageName]];
    _infoLabel.text = item.title;
    _descriptionLabel.attributedText = [[NSAttributedString alloc] initWithString:item.text];
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
