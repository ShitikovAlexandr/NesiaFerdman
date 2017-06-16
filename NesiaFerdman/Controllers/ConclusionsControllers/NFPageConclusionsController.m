//
//  NFPageConclusionsController.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 5/15/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFPageConclusionsController.h"
#import "NFSegmentedControl.h"
#import "NFDayConclusionsController.h"
#import "NFMonthConclusionsController.h"
#import "NFWeekConclusionsController.h"
#import "NFTAddImportantTaskTableViewController.h"

@interface NFPageConclusionsController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (strong, nonatomic) NSArray *viewControllersArray;
@property (strong, nonatomic) NFSegmentedControl *segmentedControl;

@end

@implementation NFPageConclusionsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.dataSource = self;
    self.title = @"Выводы";
    NSArray *itemArray = [NSArray arrayWithObjects: @"День", @"Неделя", @"Месяц", nil];
    self.segmentedControl = [[NFSegmentedControl alloc] initWithItems:itemArray];
    _segmentedControl.frame = CGRectMake(0, 0, self.view.frame.size.width - 30, 34);
    _segmentedControl.selectedSegmentIndex = 0;
    [self.navigationController.navigationBar addSubview:_segmentedControl];
    
    _segmentedControl.center = self.navigationController.navigationBar.center;
    [_segmentedControl addTarget:self action:@selector(pressSegment:) forControlEvents:UIControlEventValueChanged];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonAction)];
    addButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = addButton;
    
    NFDayConclusionsController *dayController = [self.storyboard instantiateViewControllerWithIdentifier:@"NFDayConclusionsController"];
    NFWeekConclusionsController *weekController = [self.storyboard instantiateViewControllerWithIdentifier:@"NFWeekConclusionsController"];
    NFMonthConclusionsController *monthController = [self.storyboard instantiateViewControllerWithIdentifier:@"NFMonthConclusionsController"];
    
    _viewControllersArray = [NSArray arrayWithObjects:dayController, weekController, monthController, nil];
    [self setViewControllers:@[dayController]
                   direction:UIPageViewControllerNavigationDirectionForward
                    animated:NO completion:nil];
}

#pragma mark - UIPageViewControllerDelegate, UIPageViewControllerDataSource -

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index {
    
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

- (IBAction)pressSegment:(NFSegmentedControl *)sender {
    //NSLog(@"press segment at index %ld", sender.selectedSegmentIndex);
    UIViewController *currentVC = self.viewControllers[0];
    NSUInteger currentIndex = [_viewControllersArray indexOfObject:currentVC];
    if (currentIndex < self.segmentedControl.selectedSegmentIndex) {
        [self setViewControllers:@[[self.viewControllersArray objectAtIndex:sender.selectedSegmentIndex]]
                       direction:UIPageViewControllerNavigationDirectionForward
                        animated:YES completion:nil];
    } else {
        [self setViewControllers:@[[self.viewControllersArray objectAtIndex:sender.selectedSegmentIndex]]
                       direction:UIPageViewControllerNavigationDirectionReverse
                        animated:YES completion:nil];
    }
}

- (void) addButtonAction {
    NFTAddImportantTaskTableViewController *addVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NFTAddImportantTaskTableViewController"];
    addVC.eventType = Conclusions;
    UINavigationController *navVCB = [self.storyboard instantiateViewControllerWithIdentifier:@"UINavViewController"];
    navVCB.navigationBar.barStyle = UIBarStyleBlack;
    [navVCB setViewControllers:@[addVC] animated:YES];
    [self presentViewController:navVCB animated:YES completion:nil];
    
}

@end
