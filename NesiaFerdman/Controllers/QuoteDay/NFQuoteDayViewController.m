//
//  NFQuoteDayViewController.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/11/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFQuoteDayViewController.h"
#import "NFQuoteDay.h"
#import "NFQuoteDayView.h"
#import "NFRoundButton.h"
#import "NFFirebaseSyncManager.h"
#import "NFActivityIndicatorView.h"


//QUOTE_END_LOAD
@interface NFQuoteDayViewController ()
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet NFRoundButton *nextbutton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *quoteLabel;
@property (weak, nonatomic) IBOutlet UILabel *autorLabel;
@property (strong, nonatomic) NFActivityIndicatorView *indicator;

@end

@implementation NFQuoteDayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.quoteLabel.text = @"";
    self.autorLabel.text = @"";
    self.titleLabel.text = @"Цитата дня";
    [self setCurrentDateToScreen];
   }

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData)name:QUOTE_END_LOAD object:nil];
    _indicator = [[NFActivityIndicatorView alloc] initWithView:self.view];
    [_indicator startAnimating];
    if ([[NFFirebaseSyncManager sharedManager] getQuoteList].count > 0) {
        [self updateData];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:QUOTE_END_LOAD object:nil];
}

- (void)updateData {
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:QUOTE_END_LOAD object:nil];
    [_indicator endAnimating];
    NSMutableArray *array = [NSMutableArray new];
    [array addObjectsFromArray:[[NFFirebaseSyncManager sharedManager] getQuoteList]];
    int randomIndex = arc4random_uniform((int)array.count);
    NFNQuote *quote = [array objectAtIndex:randomIndex];
    self.quoteLabel.text = quote.title;
    [self.quoteLabel sizeToFit];
    self.autorLabel.text = quote.author;
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
