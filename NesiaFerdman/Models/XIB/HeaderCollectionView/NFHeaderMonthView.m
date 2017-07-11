//
//  NFHeaderMonthView.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 7/11/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFHeaderMonthView.h"
#import "NFStyleKit.h"
#import "NFHeaderCell.h"
#import "NotifyList.h"


@interface NFHeaderMonthView()
@property (assign, nonatomic) NSInteger currentIndex;
@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;
@end

@implementation NFHeaderMonthView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    UIButton *left = [[UIButton alloc] initWithFrame:CGRectMake(8, 10, 30, 30)];
    [left setImage:[UIImage imageNamed:@"Laft_arr_heade"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(scrollLeft) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:left];
    
    UIButton *right = [[UIButton alloc] initWithFrame:CGRectMake(rect.size.width - 38, 10, 30, 30)];
    [right setImage:[UIImage imageNamed:@"Right_arr_header"] forState:UIControlStateNormal];
    [right addTarget:self action:@selector(scrollRight) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:right];
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
        [self.collectionView registerNib:[UINib nibWithNibName:@"NFHeaderCell" bundle:nil] forCellWithReuseIdentifier:@"NFHeaderCell"];
        self.sourseArray = [NSMutableArray array];
    }
    return self;
}

- (void)scrollLeft {
    if (_selectedIndex > 0) {
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:_selectedIndex - 1 inSection:0];
        _selectedIndex = newIndexPath.item;
        _currentIndex = newIndexPath.item;

        [_collectionView scrollToItemAtIndexPath:newIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
}

- (void)scrollRight {
    if (_currentIndex < _sourseArray.count - 1) {
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:_selectedIndex + 1 inSection:0];
        _selectedIndex = newIndexPath.item;
        _currentIndex = newIndexPath.item;
        [_collectionView scrollToItemAtIndexPath:newIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
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

#pragma mark - UICollectionViewDataSource -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.sourseArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NFHeaderCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"NFHeaderCell" forIndexPath:indexPath];
    NSDate *title = [self.sourseArray objectAtIndex:indexPath.item];
    cell.titleDateLabel.font = [UIFont systemFontOfSize:17.0];
    cell.titleDateLabel.text = [[self dateToString:title] uppercaseString];
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
    
    return CGSizeMake(self.collectionView.frame.size.width, self.collectionView.frame.size.height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView scrollToItemAtIndexPath:indexPath
                           atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                   animated:true];
    self.selectedIndex = indexPath.item;
    if (self.selectedIndex != self.currentIndex) {
        self.currentIndex = self.selectedIndex ;
        self.selectetDate = [self.sourseArray objectAtIndex:indexPath.item];
        NSNotification *notification = [NSNotification notificationWithName:HEADER_MONTH object:self];
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
        self.selectetDate = [self.sourseArray objectAtIndex:centerCellIndexPath.item];
        NSNotification *notification = [NSNotification notificationWithName:HEADER_MONTH object:self];
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
        self.selectetDate = [self.sourseArray objectAtIndex:centerCellIndexPath.item];
        NSNotification *notification = [NSNotification notificationWithName:HEADER_MONTH object:self];
        [[NSNotificationCenter defaultCenter]postNotification:notification];
    }
}

- (NSString *)dateToString:(NSDate *)date {
    NFDateFormatter *dateFormatter = [[NFDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"LLLL yyyy"];
    return [dateFormatter stringFromDate:date];
}

- (void)setListOfDateWithStart:(NSDate*)start end:(NSDate*)end {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitMonth
                                               fromDate:start
                                                 toDate:end
                                                options:0];
    
    NSInteger numberOfMonthes = components.month;
    
    NSDateComponents *offset = [[NSDateComponents alloc] init];
    [_sourseArray addObject:start];
    
    for (int i = 1; i <= numberOfMonthes; i++) {
        [offset setMonth:i];
        NSDate *nextMonth = [calendar dateByAddingComponents:offset toDate:start options:0];
        [self.sourseArray addObject:nextMonth];
    }
    [self.collectionView reloadData];
    [self scrollToCurrentDate];
}

- (void)scrollToCurrentDate {
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *compsDay = [cal components:NSCalendarUnitMonth | kCFCalendarUnitYear fromDate:[NSDate date]];
    for (NSDate *dateMonth in _sourseArray) {
        NSDateComponents *compMonth = [cal components:NSCalendarUnitMonth | kCFCalendarUnitYear fromDate:dateMonth];
        if ( [compMonth isEqual:compsDay]) {
            NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:[_sourseArray indexOfObject:dateMonth] inSection:0];
            _selectedIndex = newIndexPath.item;
            _currentIndex = newIndexPath.item;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [_collectionView scrollToItemAtIndexPath:newIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
            });
        }
    }
}






@end
