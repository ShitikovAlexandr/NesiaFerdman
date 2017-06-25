//
//  NFPageTaskController.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 4/18/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFPageTaskController.h"
#import "NFDayTaskController.h"
#import "NFWeekTaskController.h"
#import "NFMonthTaskController.h"
#import "NFSegmentedControl.h"
#import "NFGoogleCalendarController.h"
#import "NFEditTaskController.h"
#import "NFStatisticController.h"


@interface NFPageTaskController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (strong, nonatomic) NSArray *viewControllersArray;
@property (strong, nonatomic) NFSegmentedControl *segmentedControl;
@end

@implementation NFPageTaskController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.dataSource = self;
//    self.title = @"Календарь";
    self.navigationItem.title = @"Задачи";
    [self addMaskViewNavigationBar];

    
    NSArray *itemArray = [NSArray arrayWithObjects: @"День", @"Неделя", @"Месяц", nil];
    self.segmentedControl = [[NFSegmentedControl alloc] initWithItems:itemArray];
    _segmentedControl.frame = CGRectMake(0, 0, self.view.frame.size.width - 30, 34);
    _segmentedControl.selectedSegmentIndex = 0;
    [self.navigationController.navigationBar addSubview:_segmentedControl];
    _segmentedControl.center = self.navigationController.navigationBar.center;
    [_segmentedControl addTarget:self action:@selector(pressSegment:) forControlEvents:UIControlEventValueChanged];
    
    [self setNavigationbarButtons];
   
    NFDayTaskController *dayController = [self.storyboard instantiateViewControllerWithIdentifier:@"NFDayTaskController"];
    NFWeekTaskController *weekController = [self.storyboard instantiateViewControllerWithIdentifier:@"NFWeekTaskController"];
    NFMonthTaskController *monthController = [self.storyboard instantiateViewControllerWithIdentifier:@"NFMonthTaskController"];
    
    _viewControllersArray = [NSArray arrayWithObjects:dayController, weekController, monthController, nil];
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
    NSLog(@"addButtonAction");
    //[self navigateToGoogleCalendarScreen];
    [self navigateToEditTaskScreenWithEvent:nil];
}

- (void)resultButtonAction {
    [self navigateToResultWeekScreen];
}

- (void)navigateToGoogleCalendarScreen {
    
    NFGoogleCalendarController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NFGoogleCalendarController"];
    UINavigationController *navController = [self.storyboard instantiateViewControllerWithIdentifier:@"NFGoogleCalendarNav"];
    [navController setViewControllers:@[viewController]];
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)navigateToEditTaskScreenWithEvent:(NFEvent*)event {
    //NFEditTaskNavController
    
    NFEditTaskController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NFEditTaskController"];
    viewController.event = event;
    UINavigationController *navController = [self.storyboard instantiateViewControllerWithIdentifier:@"NFEditTaskNavController"];
    [navController setViewControllers:@[viewController]];
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)navigateToResultWeekScreen {
    NSLog(@"go to result week screen - >");
    NFStatisticController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NFStatisticController"];
    UINavigationController *navController = [self.storyboard instantiateViewControllerWithIdentifier:@"NFStatisticControllerNav"];
    [navController setViewControllers:@[viewController]];
    [self presentViewController:navController animated:YES completion:nil];
    
}

- (void)setNavigationbarButtons {
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonAction)];
    addButton.tintColor = [UIColor whiteColor];
//    self.navigationItem.rightBarButtonItem = addButton;
    
    UIBarButtonItem *resultButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"result_nav_bar_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(resultButtonAction)];
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:addButton, resultButton, nil]];
}

- (void)addMaskViewNavigationBar {
    UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 42, self.view.frame.size.width, 52.0)];
    maskView.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar addSubview:maskView];
}

@end
