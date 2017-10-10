//
//  NFAboutDataSource.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/29/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kNFAboutDataSourceText1 @"Personal Development Centre. Иерусалим."
#define kNFAboutDataSourceText2 @"http://www.nesia-ferdman.com"
#define kNFAboutDataSourceText3 @"Работаем для частных лиц и организаций (индивидуально и с компанией в целом). Мы учим использовать наилучшие возможности для достижения высокого результата. В нашем центре вы можете пройти и заказать тренинги, курсы и специализированные программы обучения - как групповые, так и индивидуальные. Тренеры центра работают в любых точках мира."


@interface NFAboutDataSource : NSObject

- (void)linkAction:(NSString*)link ;

@end
