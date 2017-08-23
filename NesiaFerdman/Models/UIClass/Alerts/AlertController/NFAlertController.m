//
//  NFAlertController.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/8/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFAlertController.h"

#define DELETE_USER_INFO        @"Все данные будут удалены из приложения!"
#define CANCEL_TITLE            @"Отмена"
#define DELETE_TITLE            @"Удалить"
#define REMOVE_FROM_GOOGLE      @"Задача так же будет удалена из Google"
#define REMOVE_EVENT            @"Вы действительно хотите удалить задачу ?"
#define DELETE_EVENT            @"Удаление задачи"
#define DELETE_PROFOLE_TITLE    @"Удалить профиль?"

@interface NFAlertController()

@end

@implementation NFAlertController

+ (void)alertDeleteProfileWithTarget:(id)target action:(SEL)userAction {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:DELETE_PROFOLE_TITLE message:DELETE_USER_INFO preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:DELETE_TITLE style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if ([target respondsToSelector:userAction]) {
            [target performSelector:userAction];
        }
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:CANCEL_TITLE style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:ok];
    [alertController addAction:cancel];
    [target presentViewController:alertController animated:YES completion:nil];
}

+ (void)alertDeleteGoogleEventWithTarget:(id)target action:(SEL)userAction {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:DELETE_EVENT message:REMOVE_FROM_GOOGLE preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:DELETE_TITLE style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [target performSelector:userAction];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:CANCEL_TITLE style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:ok];
    [alertController addAction:cancel];
    [target presentViewController:alertController animated:YES completion:nil];
}

+ (void)alertDeleteEventWithTarget:(id)target action:(SEL)userAction {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:DELETE_EVENT message:REMOVE_EVENT preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:DELETE_TITLE style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [target performSelector:userAction];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:CANCEL_TITLE style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:ok];
    [alertController addAction:cancel];
    [target presentViewController:alertController animated:YES completion:nil];
}




@end


/*
 _alertController = [UIAlertController alertControllerWithTitle:@"Error display content" message:@"Error connecting to server, no local database" preferredStyle:UIAlertControllerStyleAlert];
 
 UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
 LandingPageViewController *viewController = [[LandingPageViewController alloc] initWithNibName:nil bundle:nil];
 //            viewController.showNavBarBackButton = YES;
 [[AppDelegate sharedAppDelegate].rootViewController cPushViewController:viewController];
 }];
 [_alertController addAction:ok];
 [self presentViewController:_alertController animated:YES completion:nil];
 
 */
