//
//  NFAboutController.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/23/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFAboutController.h"
#import "UIBarButtonItem+FHButtons.h"
#import <Crashlytics/Crashlytics.h>

#define kNFAboutControllerTitle @"О нас"

@interface NFAboutController ()
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;

@end

@implementation NFAboutController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kNFAboutControllerTitle;
    [self.navigationItem setLeftButtonType:FHLeftNavigationButtonTypeBack controller:self];
    [self setData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setData {
    _label1.text = @"О нас:";
    
    _label2.text = @"Personal Development Centre. Иерусалим.\nhttp://www.nesia-ferdman.com";
    [_label2 sizeToFit];
    
    _label3.text = @"Работаем для частных лиц и организаций (индивидуально и с компанией в целом). Мы учим использовать наилучшие возможности для достижения высокого результата. В нашем Центре Вы можете пройти и заказать тренинги, курсы и специализированные программы обучения как групповые, так и индивидуальные. Тренеры центра работают в любых точках мира.";
    [_label3 sizeToFit];
}


@end
