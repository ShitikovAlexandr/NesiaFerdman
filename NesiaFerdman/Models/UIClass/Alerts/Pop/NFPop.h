//
//  NFPop.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/3/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <ISMessages/ISMessages.h>

#define kGoogleWriteError           @"Ошибка записи в Google!"
#define kGoogleReadError            @"Ошибка чтения с Google!"
#define kFirebaseWriteError         @"Ошибка записи в базу данных!"
#define kFirebaseReadError          @"Ошибка чтения с базы данных!"
#define kErrorInternetconnection    @"Проверьте интернет соединение!"
#define kWrongDatesPerion           @"Дата окончания не должна быть меньше даты начала!"
#define kLoginError                 @"Ошибка авторизации!"
#define kValueCount                 @"Добавьте ценности!"

#define kValueMaxCount              @"Количество ценностей не должно превышать 11"
#define kValueMinCount              @"Количество ценностей не должно быть меньше 7"

@interface NFPop : ISMessages

+ (void)startAlertWithMassage:(NSString *)massage;

+ (void)internetConnectionAlert;

@end
