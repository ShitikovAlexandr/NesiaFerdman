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

typedef NS_ENUM(NSInteger, MenuItem)
{
    Results,
    Values,
    Manifestations,
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
        case Results:
        {
            
            break;
        }
        case Values:
        {
            NFValueController *viewController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([NFValueController class])];
            UINavigationController *navController = [storyboard instantiateViewControllerWithIdentifier:@"NFValueControllerNav"];
            [navController setViewControllers:@[viewController]];
            [target presentViewController:navController animated:YES completion:nil];
            break;
        }
        case Manifestations:
        {
            
            break;
        }
        case Settings:
        {
            
            break;
        }
        case Training:
        {
            
            break;
        }
        case About:
        {
            
            break;
        }

        case Exit:
        {
            [[NFLoginSimpleController sharedMenuController] logout];
            break;
        }
        default:
            break;
    }
}

- (void)initItems {
    
//    NFMenuItem *calendar = [NFMenuItem new];
//    calendar.title = @"Календарь";
//    calendar.index = 0;
    
    NFMenuItem *results = [NFMenuItem new];
    results.title = @"Итоги";
    results.index = 1;
    results.imageName = @"result_icon.png";
    [_itemsArray addObject:results];
    
    NFMenuItem *myValues = [NFMenuItem new];
    myValues.title = @"Мои ценности";
    myValues.index = 2;
    myValues.imageName = @"value_icon.png";
    [_itemsArray addObject:myValues];
    
    NFMenuItem *manifestations = [NFMenuItem new];
    manifestations.title = @"Проявления";
    manifestations.index = 3;
    manifestations.imageName = @"manifestations_icon.png";
    [_itemsArray addObject:manifestations];
    
    NFMenuItem *settings = [NFMenuItem new];
    settings.title = @"Настройки";
    settings.index = 4;
    settings.imageName = @"setting_icon.png";
    [_itemsArray addObject:settings];
    
    NFMenuItem *training = [NFMenuItem new];
    training.title = @"Обучалка";
    training.index = 5;
    training.imageName =@"question_icon.png";
    [_itemsArray addObject:training];
    
    NFMenuItem *about = [NFMenuItem new];
    about.title = @"О нас";
    about.index = 6;
    about.imageName = @"about_icon.png";
    [_itemsArray addObject:about];
    
    NFMenuItem *exit = [NFMenuItem new];
    exit.title = @"Выйти";
    exit.index = 7;
    exit.imageName = @"exit_icon.png";
    [_itemsArray addObject:exit];
}


@end
