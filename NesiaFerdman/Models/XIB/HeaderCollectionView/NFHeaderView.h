//
//  NFHeaderView.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 4/14/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFDateModel.h"

@protocol NFHeaderViewProtocol <NSObject>

- (void)reselectDate;

@end

@interface NFHeaderView : UIView <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic)  UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray  *sourseArray;
@property (assign, nonatomic) BOOL displayWeeks;
@property (strong ,nonatomic) NSDate *fromDate;
@property (strong, nonatomic) NSDate *toDate;
@property (assign, nonatomic) NSInteger selectedIndex;
@property (strong, nonatomic) NSDate *selectetDate;

@property (strong, nonatomic) NFDateModel *dateSourse;


//- (void) setStartDate:(NSDate *)fromDate endDate:(NSDate *)toDate displayWeeks:(BOOL)week;

- (void)addNFDateModel:(NFDateModel *)model weeks:(BOOL)weeks;

@end
