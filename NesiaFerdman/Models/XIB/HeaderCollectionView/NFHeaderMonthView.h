//
//  NFHeaderMonthView.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 7/11/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NFHeaderMonthView : UIView <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic)  UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray  *sourseArray;
@property (strong, nonatomic) NSDate *selectetDate;
@property (assign, nonatomic) NSInteger selectedIndex;

//- (instancetype)initWithStartDate:(NSDate*)start endDate:(NSDate*)end;
- (void)setListOfDateWithStart:(NSDate*)start end:(NSDate*)end;






@end
