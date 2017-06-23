//
//  NFTutorialController.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 6/23/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFTutorialController.h"
#import "NFTutorialCell.h"
#import "UIBarButtonItem+FHButtons.h"


@interface NFTutorialController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end

@implementation NFTutorialController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setLeftButtonType:FHLeftNavigationButtonTypeBack controller:self];

    [self.collectionView registerNib:[UINib nibWithNibName:@"NFTutorialCell" bundle:nil] forCellWithReuseIdentifier:@"NFTutorialCell"];
    
    self.title = @"Обучалка";
    self.pageControl.numberOfPages = 5;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(self.collectionView.frame.size.width, self.collectionView.frame.size.height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}


#pragma mark - UICollectionViewDelegate

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NFTutorialCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NFTutorialCell" forIndexPath:indexPath];
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.pageControl.currentPage = [[[self.collectionView indexPathsForVisibleItems] firstObject] row];
}


@end
