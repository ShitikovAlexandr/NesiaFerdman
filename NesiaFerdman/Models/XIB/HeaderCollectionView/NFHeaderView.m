//
//  NFHeaderView.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 4/14/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFHeaderView.h"
#import "NFHeaderCell.h"
#import "NFWeekDateModel.h"
#import "NotifyList.h"
#import "NFStyleKit.h"

@interface NFHeaderView()
@property (assign, nonatomic) NSInteger currentIndex;
@end

@implementation NFHeaderView

- (void)addNFDateModel:(NFDateModel *)model weeks:(BOOL)weeks {
    
    self.sourseArray = [NSMutableArray array];
    self.displayWeeks = weeks;
    self.dateSourse = model;
    self.selectetDate = [NSDate date];
    [self setDataToSourse];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.collectionView.frame.size.width/4, self.collectionView.frame.size.height)];
    leftView.backgroundColor = self.collectionView.backgroundColor;
    leftView.alpha = 0.6;
    leftView.userInteractionEnabled = false;
    [self addSubview:leftView];
    
    UIView *righttView = [[UIView alloc] initWithFrame:CGRectMake(self.collectionView.frame.size.width - self.collectionView.frame.size.width/4, 0, self.collectionView.frame.size.width/3, self.collectionView.frame.size.height)];
    righttView.backgroundColor = self.collectionView.backgroundColor;
    righttView.alpha = 0.6;
    righttView.userInteractionEnabled = false;
    [self addSubview:righttView];
    [self scrollToCurrentDate];
    
    
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [NFStyleKit _borderDarkGrey];

        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:flowLayout];
        [self setUpConstraints];
        self.collectionView.collectionViewLayout = flowLayout;
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.showsVerticalScrollIndicator = NO;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        self.collectionView.backgroundColor = [NFStyleKit _base_GREY];
        [self addSubview:self.collectionView];
        
//        self.layer.shadowColor = [UIColor blackColor].CGColor;
//        self.layer.shadowOffset = CGSizeMake(0.f, 1.f);
//        self.layer.shadowRadius = 0.f;
//        self.layer.shadowOpacity = 1.f;
        
        [self.collectionView registerNib:[UINib nibWithNibName:@"NFHeaderCell" bundle:nil] forCellWithReuseIdentifier:@"NFHeaderCell"];
        self.sourseArray = [NSMutableArray array];
        
    }
    return self;
}

- (void)setUpConstraints {
    
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.collectionView];
    
    NSArray<NSLayoutConstraint *> *constraints = @[
                                                   [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.collectionView attribute:NSLayoutAttributeTop multiplier:1 constant:0],
                                                   [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.collectionView attribute:NSLayoutAttributeBottom multiplier:1 constant:1],
                                                   [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.collectionView attribute:NSLayoutAttributeLeading multiplier:1 constant:0],
                                                   [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.collectionView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]
                                                   ];
    [self addConstraints:constraints];
}

- (void)addDataToArray:(NSArray *)array {
    [self.sourseArray arrayByAddingObjectsFromArray:array];
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.sourseArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NFHeaderCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"NFHeaderCell" forIndexPath:indexPath];
    NSString *title = [self.sourseArray objectAtIndex:indexPath.item];
    cell.titleDateLabel.text = title;
    return cell;
}

#pragma mark - UICollectionViewDelegate -

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}


#pragma mark - UICollectionViewDelegateFlowLayout -

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(self.collectionView.frame.size.width/2.2 , self.collectionView.frame.size.height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView scrollToItemAtIndexPath:indexPath
                           atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                   animated:true];
    
    
    self.selectedIndex = indexPath.item;
    if (self.selectedIndex != self.currentIndex) {
        self.currentIndex = self.selectedIndex ;
        self.selectetDate = [self.dateSourse.fromToDateArray objectAtIndex:indexPath.item];
        NSNotification *notification = [NSNotification notificationWithName:HEADER_NOTIF object:self];
        [[NSNotificationCenter defaultCenter]postNotification:notification];
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSIndexPath *centerCellIndexPath =
    [self.collectionView indexPathForItemAtPoint:
     [self convertPoint:[self.collectionView center] toView:self.collectionView]];
    [self.collectionView scrollToItemAtIndexPath:centerCellIndexPath
                                atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                        animated:true];
    self.selectedIndex = centerCellIndexPath.item;
    if (self.selectedIndex != self.currentIndex) {
        self.currentIndex = self.selectedIndex ;
        self.selectetDate = [self.dateSourse.fromToDateArray objectAtIndex:centerCellIndexPath.item];
        NSNotification *notification = [NSNotification notificationWithName:HEADER_NOTIF object:self];
        [[NSNotificationCenter defaultCenter]postNotification:notification];
    }
    
    
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSIndexPath *centerCellIndexPath =
    [self.collectionView indexPathForItemAtPoint:
     [self convertPoint:[self.collectionView center] toView:self.collectionView]];
    [self.collectionView scrollToItemAtIndexPath:centerCellIndexPath
                                atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                        animated:true];
    self.selectedIndex = centerCellIndexPath.item;
    if (self.selectedIndex != self.currentIndex) {
        self.currentIndex = self.selectedIndex;
        self.selectetDate = [self.dateSourse.fromToDateArray objectAtIndex:centerCellIndexPath.item];
        NSNotification *notification = [NSNotification notificationWithName:HEADER_NOTIF object:self];
        [[NSNotificationCenter defaultCenter]postNotification:notification];
    }
    
    
    
    
}


- (NSString *)dateToString:(NSDate *)date {
    NFDateFormatter *dateFormatter = [[NFDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    return [dateFormatter stringFromDate:date];
}

- (void)setDataToSourse {
    if (self.displayWeeks) {
        
        for (NFWeekDateModel *week in self.dateSourse.weekArray) {
            NSString *titleWeek = [NSString stringWithFormat:@"%@-%@", [self dateToString:week.startOfWeek], [self dateToString:week.endOfWeek]];
            [self.sourseArray addObject:titleWeek];
        }
    } else {
        for (NSDate *dat in self.dateSourse.fromToDateArray) {
            NSString *dayTitle = [self dateToString:dat];
            [self.sourseArray addObject:dayTitle];
        }
    }
    [self.collectionView reloadData];
}

#pragma mark - NFHeaderViewProtocol

- (void)reselectDate {
}

- (void)scrollToCurrentDate {
    if (_displayWeeks) {
        for (NFWeekDateModel* week in self.dateSourse.weekArray) {
            for (NSDate *current in week.allDateOfWeek) {
                NSCalendar *calendar = [NSCalendar currentCalendar];
                [calendar setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
                if ([calendar isDate:[NSDate date] inSameDayAsDate:current]) {
                    NSInteger currentIndex = [self.dateSourse.weekArray indexOfObject:week];
                    NSIndexPath *centerCellIndexPath = [NSIndexPath indexPathForRow:currentIndex inSection:0];
                    self.selectetDate = [self.dateSourse.fromToDateArray objectAtIndex:centerCellIndexPath.item];
                    
                    [self.collectionView scrollToItemAtIndexPath:centerCellIndexPath
                                                atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                                        animated:true];
                    self.currentIndex = centerCellIndexPath.item;
                    self.selectedIndex = self.currentIndex;
                    NSNotification *notification = [NSNotification notificationWithName:HEADER_NOTIF object:self];
                    [[NSNotificationCenter defaultCenter]postNotification:notification];

                    
                    break;
                }
            }
        }
        
        /*
         [[NSCalendar currentCalendar] isDate:[NSDate date] inSameDayAsDate:currentDate]
         */
        
    } else {
        NSInteger currentIndex = [self.sourseArray indexOfObject:self.dateSourse.currentDateString];
        NSIndexPath *centerCellIndexPath = [NSIndexPath indexPathForRow:currentIndex inSection:0];
        self.selectetDate = [self.dateSourse.fromToDateArray objectAtIndex:centerCellIndexPath.item];
        
        [self.collectionView scrollToItemAtIndexPath:centerCellIndexPath
                                    atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                            animated:true];
        self.currentIndex = centerCellIndexPath.item;
        

    }
}


@end
