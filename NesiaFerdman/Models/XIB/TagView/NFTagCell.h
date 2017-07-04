//
//  NFTagCell.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 6/1/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFValue.h"
#import "NFTagView.h"


@interface NFTagCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

+ (CGSize)calculateSizeWithValue:(NFValue*)value isEditMode:(BOOL)mode;
- (void)addDataToCell:(NFValue*)value isEditMode:(BOOL)editMode;

@end
