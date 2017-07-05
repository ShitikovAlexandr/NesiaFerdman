//
//  NFPop.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 7/3/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <ISMessages/ISMessages.h>

#define kGoogleWriteError           @"Ошибка записи в Google"
#define kGoogleReadError            @"Ошибка чтения с Google"
#define kFirebaseWriteError         @"Ошибка записи в базу данных"
#define kFirebaseReadError          @"Ошибка чтения с базы данных"
#define kErrorInternetconnection    @"Проверте интернет соединение"

@interface NFPop : ISMessages




+ (void)startAlertWithMassage:(NSString *)massage;

@end
