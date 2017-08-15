//
//  NFPop.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 7/3/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFPop.h"


static BOOL isShowAlert = false;

@interface NFPop ()
@property (assign, nonatomic) BOOL isShowAlert;
@end

@implementation NFPop

@synthesize isShowAlert;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


+ (void)startAlertWithMassage:(NSString *)massage {
    
    if (!isShowAlert) {
        isShowAlert = true;
        
        UIImage *originalImage = [UIImage imageNamed:@"isInfoIconRed"];
        UIImage *newImage = [originalImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,50,50)]; // your image size
        imageView.tintColor = [UIColor redColor];  // or whatever color that has been selected
        imageView.image = newImage;
        
        ISMessages* alert = [ISMessages cardAlertWithTitle:@""
                                                   message:massage
                                                 iconImage:[UIImage imageNamed:@"isInfoIconRed"]
                                                  duration:3.f
                                               hideOnSwipe:YES
                                                 hideOnTap:YES
                                                 alertType:ISAlertTypeCustom
                                             alertPosition:ISAlertPositionTop];
        
        alert.titleLabelFont = [UIFont boldSystemFontOfSize:15.f];
        alert.titleLabelTextColor = [UIColor redColor];
        alert.messageLabelTextColor = [UIColor redColor];
        alert.alertViewBackgroundColor = [UIColor whiteColor];
        alert.view.clipsToBounds = NO;
        UIView *shadowView = [alert.view.subviews objectAtIndex:0];
        shadowView.backgroundColor = [UIColor whiteColor];
        shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
        shadowView.layer.shadowRadius = 2.f;
        shadowView.layer.shadowOpacity = 0.5;
        shadowView.layer.shadowOffset = CGSizeMake(0, 2);
        shadowView.layer.cornerRadius = 4.f;
        
        [alert show:^{
            NSLog(@"Callback is working!");
        } didHide:^(BOOL finished) {
            NSLog(@"Custom alert without image did hide.");
            isShowAlert = false;
        }];

            }
}

+ (void)internetConnectionAlert {
    if (!isShowAlert) {
        isShowAlert = true;
        [NFPop showCardAlertWithTitle:@""
                              message:kErrorInternetconnection
                             duration:3.f
                          hideOnSwipe:YES
                            hideOnTap:YES
                            alertType:ISAlertTypeWarning
                        alertPosition:ISAlertPositionTop
                              didHide:^(BOOL finished) {
                                  NSLog(@"Alert did hide.");
                                  isShowAlert = false;
                              }];
    }
    
    
    
    
}

- (void)customAlert {
    
    UIImage *originalImage = [UIImage imageNamed:@"isInfoIcon"];
    UIImage *newImage = [originalImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,50,50)]; // your image size
    imageView.tintColor = [UIColor redColor];  // or whatever color that has been selected
    imageView.image = newImage;
    
    ISMessages* alert = [ISMessages cardAlertWithTitle:@"This is custom alert with callback"
                                               message:@"This is your message!!"
                                             iconImage:imageView.image
                                              duration:3.f
                                           hideOnSwipe:YES
                                             hideOnTap:YES
                                             alertType:ISAlertTypeCustom
                                         alertPosition:ISAlertPositionTop];
				
    alert.titleLabelFont = [UIFont boldSystemFontOfSize:15.f];
    alert.titleLabelTextColor = [UIColor redColor];
    alert.messageLabelTextColor = [UIColor redColor];
    alert.alertViewBackgroundColor = [UIColor whiteColor];
    alert.view.clipsToBounds = NO;
    UIView *shadowView = [alert.view.subviews objectAtIndex:0];
    shadowView.backgroundColor = [UIColor whiteColor];
    shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
    shadowView.layer.shadowRadius = 2.f;
    shadowView.layer.shadowOpacity = 0.5;
    shadowView.layer.shadowOffset = CGSizeMake(0, 2);
    shadowView.layer.cornerRadius = 4.f;
    
    [alert show:^{
        NSLog(@"Callback is working!");
    } didHide:^(BOOL finished) {
        NSLog(@"Custom alert without image did hide.");
        isShowAlert = false;
    }];
}

@end
