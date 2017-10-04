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
    NFTutorialItem *item = [_dataArray objectAtIndex:indexPath.row];
    [cell addDataToCell:item number:indexPath.row];
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.03 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.pageControl.currentPage = [[[self.collectionView indexPathsForVisibleItems] firstObject] row];
    });
}
///Users/Alex_Shitikov/flexihouse_ios/Flexi House/FHActivitiLoader.m
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

- (void)getData {
    [_dataArray removeAllObjects];
    NFTutorialItem *item1 = [[NFTutorialItem alloc] init];
    item1.title = @"Определение ценностей";
    item1.imageName = @"onboarding1.png";
    item1.text = @"Создайте список своих ценностей. В этом вам поможет предложенный список. Так же вы можете дописывать свои ценности, которых нет в списке";
    [_dataArray addObject:item1];
    
    NFTutorialItem *item2 = [[NFTutorialItem alloc] init];
    item2.title = @"Проявления";
    item2.imageName = @"onboarding2.png";
    item2.text = @"Напишите для каждой выбранной вами ценности действия – проявления (минимум по 3 на каждую ценность).\nЭти действия внесите в календарь с указанием дня и времени реализации.";
    [_dataArray addObject:item2];
    
    NFTutorialItem *item3 = [[NFTutorialItem alloc] init];
    item3.title = @"Задачи";
    item3.imageName = @"onboarding3.png";
    item3.text = @"Вы можете присвоить ценность всем вашим повседневным задачам в календаре";
    [_dataArray addObject:item3];
    
    NFTutorialItem *item4 = [[NFTutorialItem alloc] init];
    item4.title = @"Итоги";
    item4.imageName = @"onboarding4.png";
    item4.text = @"Вписывайте ваши наблюдения в раздел «Итоги» - это поможет вам проанализировать прошедшую неделю / месяц / год";
    [_dataArray addObject:item4];
    
    NFTutorialItem *item5 = [[NFTutorialItem alloc] init];
    item5.title = @"Статистика";
    item5.imageName = @"onboarding5.png";
    item5.text = @"В разделе «статистика» вы сможете ознакомиться с вашими успехами по «проявлению ценностей» за прошедший период";
    [_dataArray addObject:item5];

}

@end
