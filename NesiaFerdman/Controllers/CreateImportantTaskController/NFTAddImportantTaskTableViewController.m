//
//  NFTAddImportantTaskTableViewController.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 5/5/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFTAddImportantTaskTableViewController.h"
#import "NFDatePicker.h"
#import "NFPickerView.h"
#import "NFSyncManager.h"
#import <UITextView+Placeholder.h>

@interface NFTAddImportantTaskTableViewController () <UITextViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (assign, nonatomic) CGRect textFrame;
@property (weak, nonatomic) IBOutlet UITextField *titleTask;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTask;
@property (strong, nonatomic) IBOutlet UITextField *dateTextField;
@property (weak, nonatomic) IBOutlet UITextField *valueTextField;
@property (strong, nonatomic) NFPickerView *valuePicker;
@property (strong, nonatomic) NSMutableArray *valuesArray;
@property (strong, nonatomic) NFDatePicker *datePicker;
@end

@implementation NFTAddImportantTaskTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.descriptionTask.placeholder = @"Описание";
    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedRowHeight = 150;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.dateTextField.text = [self stringFromDate:[NSDate date]];
    _datePicker = [[NFDatePicker alloc] initWithTextField:_dateTextField];
    _datePicker.minimumDate = [NSDate date];
    
    _valuesArray = [NSMutableArray arrayWithArray:[[NFTaskManager sharedManager] getAllValues]];
    self.valueTextField.text = ((NFValue*)([_valuesArray firstObject])).valueTitle;
    _valuePicker = [[NFPickerView alloc] initWithDataArray:_valuesArray textField:_valueTextField   keyTitle:@"valueTitle"];
    
    
}
#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 40.f;
    } else {
        return 30.f;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 1) {
        return _textFrame.size.height < 150.f ? 150 : _textFrame.size.height;
    } else {
        return UITableViewAutomaticDimension;
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (indexPath.item == 0) {
            [_dateTextField becomeFirstResponder];
        } else if (indexPath.item == 1) {
        }
    }
}



#pragma mark - Helpers

- (IBAction)pressSaveOrCancelAction:(UIBarButtonItem *)sender {
    if (sender.tag == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else if (sender.tag == 2) {
        NFValue *val = [self.valuesArray objectAtIndex:[_valuePicker.selectedIndex integerValue]];
        NFEvent *newEvent = [NFEvent new];
        newEvent.title = self.titleTask.text;
        newEvent.eventDescription = self.descriptionTask.text;
        newEvent.startDate = [NSString stringWithFormat:@"%@",_datePicker.selectedDate];
        //newEvent.value = [val convertToDictionary];
        newEvent.socialType = NesiaEvent;
        newEvent.eventType = _eventType;
        //[[NFSyncManager sharedManager] writeEventToFirebase:newEvent];
        //[[NFTaskManager sharedManager] convertToDictionary:[NFTaskManager sharedManager].eventConclusionsDictionary array:[NSMutableArray arrayWithObject:newEvent]];
        NSLog(@"controller from dissmiss %@", self.navigationController.presentingViewController);

        [self dismissViewControllerAnimated:YES completion:nil];
    }

}

- (NSString *)stringFromDate:(NSDate *)date {
    NSDateFormatter *dateFormater = [NSDateFormatter new];
    [dateFormater setDateFormat:@"LLLL, dd, yyyy HH:mm"];
    return [dateFormater stringFromDate:date];
}

#pragma mark - UITextView

- (void)textViewDidChange:(UITextView *)textView {
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    if (newFrame.size.height != textView.frame.size.height) {
        textView.frame = newFrame;
        self.textFrame = newFrame;
        NSLog(@"new frame height ");
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        [textView becomeFirstResponder];
    }
}

@end
