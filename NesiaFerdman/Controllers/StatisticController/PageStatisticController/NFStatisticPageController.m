//
//  NFStatisticPageController.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/14/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFStatisticPageController.h"
#import "NFStatisticDayController.h"
#import "NFStatisticWeekController.h"
#import "NFStatisticMonthController.h"
#import "NFStatisticRandomPeriodController.h"
#import "UIBarButtonItem+FHButtons.h"

#import "NFSegmentedControl.h"


@interface NFStatisticPageController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource>
@property (strong, nonatomic) NSArray *viewControllersArray;
@property (strong, nonatomic) NFSegmentedControl *segmentedControl;
@property (assign, nonatomic) BOOL isScroll;
@end

@implementation NFStatisticPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.dataSource = self;
    self.navigationItem.title = @"Статистика";
    self.tabBarItem.title = @"Статистика";
    [self setNavigationButton];
    [self addMaskViewNavigationBar];
    
    NSArray *itemArray = [NSArray arrayWithObjects: @"День", @"Неделя", @"Месяц", @"Другое", nil];
    self.segmentedControl = [[NFSegmentedControl alloc] initWithItems:itemArray];
    _segmentedControl.frame = CGRectMake(0, 49, self.view.frame.size.width - 30, 34);
    _segmentedControl.selectedSegmentIndex = 0;
    [self.navigationController.navigationBar addSubview:_segmentedControl];
    _segmentedControl.center = CGPointMake(self.navigationController.navigationBar.center.x, self.navigationController.navigationBar.center.y + 20.0);
    [_segmentedControl addTarget:self action:@selector(pressSegment:) forControlEvents:UIControlEventValueChanged];
    
    NFStatisticDayController *dayController = [self.storyboard instantiateViewControllerWithIdentifier:@"NFStatisticDayController"];
    NFStatisticWeekController *weekController = [self.storyboard instantiateViewControllerWithIdentifier:@"NFStatisticWeekController"];
    NFStatisticMonthController *monthController = [self.storyboard instantiateViewControllerWithIdentifier:@"NFStatisticMonthController"];
    NFStatisticRandomPeriodController *randomPeriodController = [self.storyboard instantiateViewControllerWithIdentifier:@"NFStatisticRandomPeriodController"];
    
    _viewControllersArray = [NSArray arrayWithObjects:dayController, weekController, monthController, randomPeriodController, nil];
    [self setViewControllers:@[dayController]
                   direction:UIPageViewControllerNavigationDirectionForward
                    animated:NO completion:nil];
}


#pragma mark - UIPageViewControllerDelegate, UIPageViewControllerDataSource -

-(UIViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    return _viewControllersArray[index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger currentIndex = [_viewControllersArray indexOfObject:viewController];
    // get the index of the current view controller on display
    
    if (currentIndex > 0)
    {
        return [_viewControllersArray objectAtIndex:currentIndex-1];
        
        // return the previous viewcontroller
    } else
    {
        return nil;
        // do nothing
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger currentIndex = [_viewControllersArray indexOfObject:viewController];
    // get the index of the current view controller on display
    // check if we are at the end and decide if we need to present
    // the next viewcontroller
    
    if (currentIndex < [_viewControllersArray count]-1)
    {
        return [_viewControllersArray objectAtIndex:currentIndex+1];
        // return the next view controller
    } else
    {
        return nil;
        // do nothing
    }
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
        UIViewController *currentVC = self.viewControllers[0];
        NSUInteger currentIndex = [_viewControllersArray indexOfObject:currentVC];
        self.segmentedControl.selectedSegmentIndex = currentIndex;
    }
}

-(NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return 0;
}

#pragma mark - Actions

- (IBAction)pressSegment:(NFSegmentedControl *)sender {
    UIViewController *currentVC = self.viewControllers[0];
    NSUInteger currentIndex = [_viewControllersArray indexOfObject:currentVC];

    if (!_isScroll) {
        _isScroll = true;
               if (currentIndex < self.segmentedControl.selectedSegmentIndex) {
            [self setViewControllers:@[[self.viewControllersArray objectAtIndex:sender.selectedSegmentIndex]]
                           direction:UIPageViewControllerNavigationDirectionForward
                            animated:YES completion:nil];
        } else {
            [self setViewControllers:@[[self.viewControllersArray objectAtIndex:sender.selectedSegmentIndex]]
                           direction:UIPageViewControllerNavigationDirectionReverse
                            animated:YES completion:nil];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _isScroll = false;
        });

    } else {
        sender.selectedSegmentIndex = currentIndex;
    }
    
}

#pragma mark - Helpers

- (void)addMaskViewNavigationBar {
    UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 42, self.view.frame.size.width, 52.0)];
    maskView.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar addSubview:maskView];
}

- (void)setNavigationButton {
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back_standart.png"]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self action:@selector(exitAction)];
    self.navigationItem.leftBarButtonItem = backButton;
}

- (void)exitAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
