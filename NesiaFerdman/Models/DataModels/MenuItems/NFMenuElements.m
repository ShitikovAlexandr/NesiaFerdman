//
//  NFMenuElements.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 6/8/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFMenuElements.h"
#import "NFMenuItem.h"

#import "NFLoginSimpleController.h"
#import "NFValueController.h"
#import "NFResultController.h"
#import "NFStatisticController.h"
#import "NFAboutController.h"
#import "NFTutorialController.h"
#import "NFManifestationsController.h"
#import "NFSettingDetailController.h"
#import "NFStatisticPageController.h"
#import "NFNSyncManager.h"



typedef NS_ENUM(NSInteger, MenuItem)
{
   // Results,
    Statistic,
    Values,
    //Manifestations,
    Settings,
    Training,
    About,
    Exit
};

@implementation NFMenuElements

- (instancetype)init {
    self = [super init];
    if (self) {
        self.itemsArray = [NSMutableArray array];
        [self initItems];
    }
    return self;
}

+ (void)navigateToScreenWithIndex:(NSInteger)index target:(id)target {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
                                    @"Main" bundle:[NSBundle mainBundle]];
    switch (index) {
//        case Results:
//        {
//            NFResultController *viewController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([NFResultController class])];
//            UINavigationController *navController = [storyboard instantiateViewControllerWithIdentifier:@"NFResultControllerNav"];
//            [navController setViewControllers:@[viewController]];
//            [target presentViewController:navController animated:YES completion:nil];
//            
//            break;
//        }
        case Statistic:
        {
            //NFStatisticController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"NFStatisticController"];
            NFStatisticPageController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"NFStatisticPageController"];
            UINavigationController *navController = [storyboard instantiateViewControllerWithIdentifier:@"NFStatisticPageControllerNav"];
            [navController setViewControllers:@[viewController]];
            [target presentViewController:navController animated:YES completion:nil];
            break;
        }

        case Values:
        {
            NFValueController *viewController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([NFValueController class])];
            viewController.screenState = ViewValue;
            UINavigationController *navController = [storyboard instantiateViewControllerWithIdentifier:@"NFValueControllerNav"];
            [navController setViewControllers:@[viewController]];
            [target presentViewController:navController animated:YES completion:nil];
            break;
        }
//        case Manifestations:
//        {
//            NFManifestationsController *viewController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([NFManifestationsController class])];
//            UINavigationController *navController = [storyboard instantiateViewControllerWithIdentifier:@"NFManifestationsControllerNav"];
//            [navController setViewControllers:@[viewController]];
//            [target presentViewController:navController animated:YES completion:nil];
//            break;
//        }
        case Settings:
        {
            NFSettingDetailController *viewController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([NFSettingDetailController class])];
            UINavigationController *navController = [storyboard instantiateViewControllerWithIdentifier:@"NFSettingDetailControllerNav"];
            [navController setViewControllers:@[viewController]];
            [target presentViewController:navController animated:YES completion:nil];
            break;
        }
        case Training:
        {
            NFTutorialController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"NFTutorialController"];
            UINavigationController *navController = [storyboard instantiateViewControllerWithIdentifier:@"NFTutorialControllerNav"];
            [navController setViewControllers:@[viewController]];
            [target presentViewController:navController animated:YES completion:nil];
            
            break;
        }
        case About:
        {
            NFAboutController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"NFAboutController"];
            UINavigationController *navController = [storyboard instantiateViewControllerWithIdentifier:@"NFAboutControllerNav"];
            [navController setViewControllers:@[viewController]];
            [target presentViewController:navController animated:YES completion:nil];
            break;
        }

        case Exit:
            
        {
            UIViewController *vc = target;
            [vc.navigationController dismissViewControllerAnimated:YES completion:NULL];
            [[NFLoginSimpleController sharedMenuController] logout];
            

            break;
        }
        default:
            break;
    }
}

- (void)initItems {
    

    
//    NFMenuItem *results = [NFMenuItem new];
//    results.title = @"Итоги недели";
//    results.index = 1;
//    results.imageName = @"result_NEW_icon.png";
//    [_itemsArray addObject:results];
    
    NFMenuItem *statistic = [NFMenuItem new];
    statistic.title = @"Статистика";
    statistic.index = 2;
    statistic.imageName = @"statistic_NEW_icon.png";
    [_itemsArray addObject:statistic];
    
    NFMenuItem *myValues = [NFMenuItem new];
    myValues.title = @"Мои ценности";
    myValues.index = 3;
    myValues.imageName = @"value_icon.png";
    [_itemsArray addObject:myValues];
    
//    NFMenuItem *manifestations = [NFMenuItem new];
//    manifestations.title = @"Проявления";
//    manifestations.index = 4;
//    manifestations.imageName = @"manifestations_icon.png";
//    [_itemsArray addObject:manifestations];
    
    NFMenuItem *settings = [NFMenuItem new];
    settings.title = @"Настройки";
    settings.index = 5;
    settings.imageName = @"setting_icon.png";
    [_itemsArray addObject:settings];
    
    NFMenuItem *training = [NFMenuItem new];
    training.title = @"Обучалка";
    training.index = 6;
    training.imageName =@"question_icon.png";
    [_itemsArray addObject:training];
    
    NFMenuItem *about = [NFMenuItem new];
    about.title = @"О нас";
    about.index = 7;
    about.imageName = @"about_icon.png";
    [_itemsArray addObject:about];
    
//    NFMenuItem *support = [NFMenuItem new];
//    support.title = @"Итоги недели";
//    support.index = 1;
//    support.imageName = @"result_NEW_icon.png";
//    [_itemsArray addObject:support];
//
    
    NFMenuItem *exit = [NFMenuItem new];
    exit.title = @"Выйти";
    exit.index = 8;
    exit.imageName = @"exit_icon.png";
    [_itemsArray addObject:exit];
}


@end
