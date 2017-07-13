//
//  NFDatePicker.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 5/5/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFDatePicker.h"

@interface NFDatePicker()
@property (strong, nonatomic) UITextField *textfield;
@property (strong, nonatomic) UIToolbar *toolBar;

@end

@implementation NFDatePicker

- (instancetype)initWithTextField:(UITextField *)textField {
    self = [super init];
    
    if (self) {
        self.textfield = textField;
        //        self.frame = CGRectMake(0, 0, 320, 100);
        
        self.layer.backgroundColor = [UIColor whiteColor].CGColor;
        self.layer.shadowColor = [UIColor grayColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0.f, -3.0f);
        self.layer.shadowRadius = 3;
        self.layer.shadowOpacity = 3;
        self.layer.masksToBounds = NO;


        
        self.selectedDate = [NSDate date];
        //[self setLocale:[NSLocale systemLocale]];
        
        UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"OK" style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonPressed:)];
        UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        self.toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
        
        [self.toolBar setTintColor:[UIColor grayColor]];
        [self.toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
        [textField setInputAccessoryView:self.toolBar];
        [textField setInputView:self];
        
        [self addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventValueChanged];
        
    }
    return self;
}

- (void) doneButtonPressed:(id)sender  {
    [self.textfield resignFirstResponder];
}

- (NSString *)stringFromDate:(NSDate *)date {
    NFDateFormatter *dateFormater = [NFDateFormatter new];
    [dateFormater setDateFormat:@"LLLL, dd, yyyy HH:mm"];
    return [dateFormater stringFromDate:date];
}

- (NSString *)stringFromDateOnly:(NSDate *)date {
    NFDateFormatter *dateFormater = [NFDateFormatter new];
    [dateFormater setDateFormat:@"LLLL, dd, yyyy"];
    return [dateFormater stringFromDate:date];
}

- (void)textFieldDidChange:(UIDatePicker*) datePicker {
    if (_onlyDate) {
         self.textfield.text = [self stringFromDateOnly:self.date];
    } else {
        self.textfield.text = [self stringFromDate:self.date];
    }
    self.selectedDate = self.date;
}



@end
