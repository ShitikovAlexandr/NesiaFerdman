//
//  NFAboutController.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/23/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFAboutController.h"
#import "UIBarButtonItem+FHButtons.h"
#import "NFAboutDataSource.h"

#define kNFAboutControllerTitle @"О нас"

@interface NFAboutController ()
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UIButton *linkButton;
@property (strong, nonatomic) NFAboutDataSource *dataSource;

@end

@implementation NFAboutController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSource = [[NFAboutDataSource alloc]init];
    self.title = kNFAboutControllerTitle;
    [self.navigationItem setLeftButtonType:FHLeftNavigationButtonTypeBack controller:self];
    [self setData];
}

- (void)setData {
    _label1.text = kNFAboutDataSourceText1;
    [_linkButton setTitle:kNFAboutDataSourceText2 forState:UIControlStateNormal];
    [_label2 sizeToFit];
    _label3.text = kNFAboutDataSourceText3;
    [_label3 sizeToFit];
}

- (IBAction)buttonAction:(UIButton *)sender {
    [_dataSource linkAction:kNFAboutDataSourceText2];
}



@end
