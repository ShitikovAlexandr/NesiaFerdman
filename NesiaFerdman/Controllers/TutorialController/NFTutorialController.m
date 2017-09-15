//
//  NFTutorialController.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/23/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFTutorialController.h"
#import "NFTutorialCell.h"
#import "UIBarButtonItem+FHButtons.h"
#import "NFTutorialItem.h"

#define kNFTutorialControllerTitle  @"Обучалка"
#define kNFTutorialControllerDone   @"Готово"


@interface NFTutorialController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation NFTutorialController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [NSMutableArray new];
    [self getData];
    [self setNavigationButtons];
    [self.collectionView registerNib:[UINib nibWithNibName:@"NFTutorialCell" bundle:nil] forCellWithReuseIdentifier:@"NFTutorialCell"];
    self.title = kNFTutorialControllerTitle;
    self.pageControl.numberOfPages = _dataArray.count;
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

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NFTutorialCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NFTutorialCell" forIndexPath:indexPath];
    [cell addDataToCell:[_dataArray objectAtIndex:indexPath.item] index:indexPath.row];
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.03 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.pageControl.currentPage = [[[self.collectionView indexPathsForVisibleItems] firstObject] row];
    });
}

- (void) setNavigationButtons {
    if (_isFirstRun) {
        UIBarButtonItem *rigtButton = [[UIBarButtonItem alloc] initWithTitle:kNFTutorialControllerDone style:UIBarButtonItemStylePlain target:self action:@selector (goNextAction)];
        self.navigationItem.rightBarButtonItem = rigtButton;
        self.navigationItem.rightBarButtonItem.customView.hidden = NO;
        [self.navigationItem setLeftButtonType:FHLeftNavigationButtonTypeBack controller:self];

    } else {
        [self.navigationItem setLeftButtonType:FHLeftNavigationButtonTypeBack controller:self];
    }
}

- (void)goNextAction {
    [self.navigationController pushViewController:_nextController animated:YES];
}

- (NSMutableArray*)getImageTest {
    NSMutableArray* array = [NSMutableArray new];
    for (int i = 16 ; i < 20; i++) {
        NSString *imgName = [NSString stringWithFormat:@"IMG_27%d.png",i];
        UIImage *img = [[UIImage alloc] init];
        img = [UIImage imageNamed:imgName];
        [array addObject:img];
    }
    return array;
}

- (void)getData {
    [_dataArray removeAllObjects];
    NFTutorialItem *item1 = [[NFTutorialItem alloc] init];
    item1.title = @"";
    item1.imageName = @"";
    item1.text = @"";
    [_dataArray addObject:item1];
    
    NFTutorialItem *item2 = [[NFTutorialItem alloc] init];
    item2.title = @"";
    item2.imageName = @"";
    item2.text = @"";
    [_dataArray addObject:item2];
    
    NFTutorialItem *item3 = [[NFTutorialItem alloc] init];
    item3.title = @"";
    item3.imageName = @"";
    item3.text = @"";
    [_dataArray addObject:item3];
}

@end
