//
//  NFTagView.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/2/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFTagView.h"
#import "NFStyleKit.h"

@interface NFTagView()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation NFTagView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
    UIView *subview = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
    subview.frame = self.bounds;
    subview.backgroundColor = [UIColor whiteColor];
    [self addSubview:subview];
    
    
    self.cancelButton.layer.cornerRadius = self.cancelButton.frame.size.height/2.0;
    self.layer.masksToBounds = true;
}

- (instancetype)initWithText:(NSString *)text andPoint:(CGPoint)position {
    self = [super init];
    if (self) {
        
        //self.frame = CGRectMake(position.x, position.y, [self calculateSizeWithText:text], 44.f);
        
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
        UIView *subview = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
        subview.frame = self.bounds;
        subview.backgroundColor = [NFStyleKit _lightGrey];
        [self addSubview:subview];
    }
    return self;
}


- (CGFloat)calculateSizeWithText:(NSString*)text andMainView:(UIView *)view{
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    [label sizeToFit];
    return label.frame.size.width + 60.f;
}

- (void)layoutSubviews {
    self.layer.cornerRadius = self.frame.size.height/2.0;
    self.layer.masksToBounds = true;

}

- (void)setTitleWithValue:(NFValue *)value {
    
}

@end
