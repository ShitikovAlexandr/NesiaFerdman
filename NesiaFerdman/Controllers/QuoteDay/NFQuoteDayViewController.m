//
//  NFQuoteDayViewController.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 4/11/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFQuoteDayViewController.h"
#import "NFQuoteDay.h"
#import "NFQuoteDayView.h"
#import "NFRoundButton.h"
//#import "NFGoogleManager.h"
//#import "NFFirebaseManager.h"
#import "NFEvent.h"
#import "NFSyncManager.h"


@interface NFQuoteDayViewController ()
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet NFRoundButton *nextbutton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *quoteLabel;
@property (weak, nonatomic) IBOutlet UILabel *autorLabel;
@end

@implementation NFQuoteDayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"Цитата дня";
    NFQuoteDay *day = [[NFQuoteDay alloc] initTestData];
    self.quoteLabel.text = day.quote;
    [self.quoteLabel sizeToFit];
    self.autorLabel.text = day.autor;
    [self setCurrentDateToScreen];
    
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (IBAction)goNextAction:(NFRoundButton *)sender {
    NSLog(@"go next from quote of the day to the calendar ->");
    
}

- (void)setCurrentDateToScreen {
    NSDate *currentDate = [NSDate date];
    self.dayLabel.text = [self stringFromDate:currentDate withFormat:@"dd"];
    self.monthLabel.text = [self stringFromDate:currentDate withFormat:@"MMMM"];
    
}

- (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString*)formar {
    NFDateFormatter *dateFormater = [NFDateFormatter new];
    [dateFormater setDateFormat:formar];
    return [dateFormater stringFromDate:date];
}

@end
