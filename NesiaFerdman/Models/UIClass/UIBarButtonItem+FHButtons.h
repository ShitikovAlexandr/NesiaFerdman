//
//  UIBarButtonItem+FHButtons.h
//  Flexi House
//
//  Created by Igor Iliyn on 4/25/17.
//  Copyright © 2017 Igor Iliyn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FHLeftNavigationButtonType) {
    FHLeftNavigationButtonTypeNone,
    FHLeftNavigationButtonTypeMenu,
    FHLeftNavigationButtonTypeBack
};

typedef NS_ENUM(NSInteger, FHRightNavigationButtonType) {
    FHRightNavigationButtonTypeNone,
    FHRightNavigationButtonTypeGear,
    FHRightNavigationButtonTypeSyncGear
};

@interface UINavigationItem (FHButtons)

- (void)setLeftButtonType:(FHLeftNavigationButtonType)leftButtonType controller:(UIViewController*)target;
- (void)setRightButtonType:(FHRightNavigationButtonType)rightButtonType controller:(UIViewController*)target;



@end
