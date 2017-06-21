//
//  UIBarButtonItem+FHButtons.m
//  Flexi House
//
//  Created by Igor Iliyn on 4/25/17.
//  Copyright © 2017 Igor Iliyn. All rights reserved.
//

#import "UIBarButtonItem+FHButtons.h"
#import <objc/runtime.h>

@interface UINavigationItem()

@property (nonatomic) FHLeftNavigationButtonType leftButtonType;
@property (nonatomic) FHRightNavigationButtonType rightButtonType;
@property (nonatomic, weak) UIViewController *viewController;

@end

@implementation UINavigationItem (FHButtons)

#pragma mark - Left button -

- (void)setLeftButtonType:(FHLeftNavigationButtonType)leftButtonType controller:(UIViewController *)target {
    self.leftButtonType = leftButtonType;
    self.viewController = target;
    [self setHidesBackButton:YES];
    switch (leftButtonType) {
        case FHLeftNavigationButtonTypeNone:
            self.leftBarButtonItem = nil;
            self.leftBarButtonItems = nil;
            break;
        case FHLeftNavigationButtonTypeBack:
            self.leftBarButtonItem = [self customBackBarButtonItem];
            break;
        case FHLeftNavigationButtonTypeMenu:
            self.leftBarButtonItem = [self customMenuBarButtonItem];
            break;
    }
}

- (UIBarButtonItem *)customBackBarButtonItem {
    return [self barButtonItemWithImageName:@"Back_standart.png" action:@selector(goBack)];
}

- (UIBarButtonItem *)customMenuBarButtonItem {
    return [self barButtonItemWithImageName:@"menu_icon" action:@selector(goBack)];
}

#pragma mark - Right button -

- (void)setRightButtonType:(FHRightNavigationButtonType)rightButtonType controller:(UIViewController *)target {
    self.rightButtonType = rightButtonType;
    self.viewController = target;
    switch (rightButtonType) {
        case FHRightNavigationButtonTypeNone:
            self.rightBarButtonItem = [self customNoneButtonItem];
            break;
        case FHRightNavigationButtonTypeGear:
            self.rightBarButtonItem = [self customGearButtonItem];
            break;
        case FHRightNavigationButtonTypeSyncGear:
            self.rightBarButtonItems = [self customSyncGearButtonItems];
            break;
        default:
            self.rightBarButtonItem = nil;
            break;
    }
}

- (UIBarButtonItem *)customNoneButtonItem {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    return item;
}

- (UIBarButtonItem *)customGearButtonItem {
    return [self barButtonItemWithImageName:@"white_gear_icon" action:@selector(goNext)];
}

- (NSArray<UIBarButtonItem *> *)customSyncGearButtonItems {
    NSArray <UIBarButtonItem *> *items = nil;
    UIBarButtonItem *item1 = [self barButtonItemWithImageName:@"white_gear_icon" action:@selector(gearPressed)];
    UIBarButtonItem *item2 = [self barButtonItemWithImageName:@"utilities_sync_icon" action:@selector(syncPressed)];
    items = [NSArray arrayWithObjects:item1, item2, nil];
    return items;
}

#pragma mark - Helpers -

- (void)setLeftButtonType:(FHLeftNavigationButtonType)leftButtonType {
    objc_setAssociatedObject(self, @selector(leftButtonType), [NSNumber numberWithInteger:leftButtonType] , OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setRightButtonType:(FHRightNavigationButtonType)rightButtonType {
    objc_setAssociatedObject(self, @selector(rightButtonType), [NSNumber numberWithInteger:rightButtonType] , OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (void)setViewController:(UIViewController *)viewController{
    objc_setAssociatedObject(self, @selector(viewController), viewController , OBJC_ASSOCIATION_ASSIGN);
}

- (UIViewController *)viewController {
    return objc_getAssociatedObject(self, @selector(viewController));
}


- (UIBarButtonItem *)barButtonItemWithImageName:(NSString *)imageName action:(SEL)action {
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(0, 0, 28, 28);
    UIImage *image = [UIImage imageNamed:imageName];
    [nextButton setImage:image forState:UIControlStateNormal];
    [nextButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:nextButton];
    item.tintColor = [UIColor whiteColor];
    [item setTitle:@""];
//    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor clearColor]} forState:UIControlStateNormal];
    return item;
}

- (void)goBack {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    if ([self.viewController respondsToSelector:@selector(backButtonPressed)]) {
        [self.viewController performSelector:@selector(backButtonPressed)];
        return;
    }
#pragma clang diagnostic pop
    
    if (self.viewController.navigationController.viewControllers.count > 1) {
        [self.viewController.navigationController popViewControllerAnimated:YES];
        return;
    } else if (self.viewController.navigationController.viewControllers.count == 1 && self.viewController.navigationController.presentingViewController) {
        [self.viewController.navigationController dismissViewControllerAnimated:YES completion:^{
        }];
        return;
    }
}

-(void)doneEditing {
    if ([self.viewController respondsToSelector:@selector(doneEditing)]){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        [self.viewController performSelector:@selector(doneEditing)];
#pragma clang diagnostic pop
        
    }
}

- (void)goNext {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    if ([self.viewController respondsToSelector:@selector(swipeButtonPressed)])
        [self.viewController performSelector:@selector(swipeButtonPressed)];
#pragma clang diagnostic pop
}

- (void)gearPressed {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    if ([self.viewController respondsToSelector:@selector(gearButtonPressed)])
        [self.viewController performSelector:@selector(gearButtonPressed)];
#pragma clang diagnostic pop
}

- (void)syncPressed {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    if ([self.viewController respondsToSelector:@selector(syncButtonPressed)])
        [self.viewController performSelector:@selector(syncButtonPressed)];
#pragma clang diagnostic pop
}

@end
