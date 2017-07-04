//
//  NFEditTaskController.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 5/31/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFEditTaskController.h"
#import "NFDatePicker.h"
#import "NFPickerView.h"
#import "NFSyncManager.h"
#import <UITextView+Placeholder.h>
#import "NFTagView.h"
#import "NFChackBox.h"
#import "NFTagCell.h"
#import "NFActivityIndicatorView.h"
#import "NFSettingManager.h"
#import "NFTextField.h"
#import "NFTextView.h"
#import "UIBarButtonItem+FHButtons.h"



@interface NFEditTaskController ()
<
UITextViewDelegate,
UITextFieldDelegate,
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UILabel *valueTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *selectValueTextField;
@property (weak, nonatomic) IBOutlet NFTextField *titleOfTaskTextField;
@property (weak, nonatomic) IBOutlet NFTextView *taskDescriptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *startLabel;
@property (weak, nonatomic) IBOutlet UITextField *starttextField;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;
@property (weak, nonatomic) IBOutlet UITextField *endTextField;
@property (weak, nonatomic) IBOutlet UILabel *compliteLabel;
@property (weak, nonatomic) IBOutlet NFChackBox *compliteButton;
@property (strong, nonatomic) NFPickerView *valuePicker;
@property (strong, nonatomic) NSMutableArray *valuesArray;
@property (strong, nonatomic) NFDatePicker *datePickerStart;
@property (strong, nonatomic) NFDatePicker *datePickerEnd;
@property (assign, nonatomic) CGRect textFrame;
@property (strong, nonatomic) NSMutableArray *selectedTags;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (strong, nonatomic) NFActivityIndicatorView *indicator;
@property (assign, nonatomic) BOOL isEditing;
@property (assign, nonatomic) CGFloat standartSize;
@end

@implementation NFEditTaskController

- (void)viewDidLoad {
    [super viewDidLoad];
    _standartSize = 44.0;
    _isEditing = false;
    self.selectedTags = [NSMutableArray array];
    self.tableView.estimatedRowHeight = 90;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self setStartDataToDisplay];
    [self configurePickers];
    [self.compliteButton addTarget:self action:@selector(compliteTaskAction) forControlEvents:UIControlEventTouchDown];
    [self.collectionView registerNib:[UINib nibWithNibName:@"NFTagCell" bundle:nil] forCellWithReuseIdentifier:@"NFTagCell"];
    [self.collectionView reloadData];
    [self.deleteButton addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
    [_titleOfTaskTextField validateWithTarget:self placeholderText:@"Заглавие"];
    [_taskDescriptionTextView validateWithTarget:self
                                 placeholderText:@"Описание" min:0 max:300];
    if (_event) {
        [self setPreviewOptions];
    } else {
        [self setEditOptions];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addDataToDisplay) name:PICKER_VIEW_IS_PRESSED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endUpdate) name:END_UPDATE_DATA object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PICKER_VIEW_IS_PRESSED object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:END_UPDATE_DATA object:nil];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 4) {
        return _textFrame.size.height < 90.f ? 90 : _textFrame.size.height;
    } else if (indexPath.row == 2) {
        return 62.0;
    } else  if (indexPath.row == 0 || indexPath.row == 1) {
        if (!_isEditing) {
            return 0;
        } else {
            return _standartSize;
        }
    } else {
        return UITableViewAutomaticDimension;
    }
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
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        [textView becomeFirstResponder];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


#pragma mark - Actions

- (IBAction)saveOrCancelAction:(UIBarButtonItem *)sender {
    if (sender.tag == 2) {
        [self saveChanges];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Helpers

- (NSString *)stringFromDate:(NSDate *)date {
    NFDateFormatter *dateFormater = [NFDateFormatter new];
    [dateFormater setDateFormat:@"LLLL, dd, yyyy HH:mm"];
    return [dateFormater stringFromDate:date];
}

//@"LLLL, dd, yyyy HH:mm"
//2017-04-27T15:30

- (NSString *)stringDate:(NSString *)stringInput
              withFormat:(NSString *)inputFormat
      dateStringToFromat:(NSString*)outputFormat {
    
    NFDateFormatter *dateFormatter = [[NFDateFormatter alloc] init];
    [dateFormatter setDateFormat:inputFormat];
    NSDate *dateFromString = [dateFormatter dateFromString:stringInput];
    NFDateFormatter *dateFormatter1 = [[NFDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:outputFormat];
    NSString* newDate = [dateFormatter1 stringFromDate:dateFromString];
    return newDate;
}

- (void)setStartDataToDisplay {
    self.taskDescriptionTextView.placeholder = @"Описание";
    [self.deleteButton setTitle:@"Удалить задачу" forState:UIControlStateNormal];
    _indicator = [[NFActivityIndicatorView alloc] initWithView:self.view];
    [_selectedTags removeAllObjects];
    [_selectedTags addObjectsFromArray:_event.values];
    if (_event) {
        self.deleteButton.hidden = NO;
        self.titleOfTaskTextField.text = _event.title;
        
        if (_event.eventDescription.length > 0) {
            self.taskDescriptionTextView.text = _event.eventDescription;
        }
        self.starttextField.text = [self stringDate:_event.startDate
                                         withFormat:@"yyyy-MM-dd'T'HH:mm:ss"
                                 dateStringToFromat:@"LLLL, dd, yyyy HH:mm"];
        
        self.endTextField.text = [self stringDate:_event.endDate
                                       withFormat:@"yyyy-MM-dd'T'HH:mm:ss"
                               dateStringToFromat:@"LLLL, dd, yyyy HH:mm"];
        self.compliteButton.selected = _event.isDone;
    } else {
        self.deleteButton.hidden = YES;
//        [self.saveButton setTitle:@"Сохранить"];
        self.title = @"Создание задачи";
        self.starttextField.text = [self stringFromDate:[NSDate date]];
        self.endTextField.text = [self stringFromDate:[NSDate  dateWithTimeIntervalSinceNow:900]];
        
    }
    [self.collectionView reloadData];
}

- (void)configurePickers {
    _datePickerStart = [[NFDatePicker alloc] initWithTextField:_starttextField];
    _datePickerStart.minimumDate = [NSDate date];
    _datePickerEnd = [[NFDatePicker alloc] initWithTextField:_endTextField];
    _datePickerEnd.minimumDate = _datePickerStart.minimumDate;
    
    _valuesArray = [NSMutableArray arrayWithArray:[[NFTaskManager sharedManager] getAllValues]];
    //self.selectValueTextField.text = ((NFValue*)([_valuesArray firstObject])).valueTitle;
    _valuePicker = [[NFPickerView alloc] initWithDataArray:_valuesArray textField:_selectValueTextField   keyTitle:@"valueTitle"];
}

- (void)addDataToDisplay {
    if (_selectedTags.count < 2) {
        if (_selectedTags.count == 1) {
            NFValue *val = [_selectedTags firstObject];
            if ([val.valueId isEqualToString:[_valuePicker.lastSelectedItem valueId]]) {
                NSLog(@"value alredy exist");
            } else {
                [_selectedTags addObject:_valuePicker.lastSelectedItem];
                [self.collectionView.layer addAnimation:[self swipeTransitionToLeftSide:YES ] forKey:nil];
                [self.collectionView reloadData];
            }
        } else {
            [_selectedTags addObject:_valuePicker.lastSelectedItem];
            [self.collectionView.layer addAnimation:[self swipeTransitionToLeftSide:YES ] forKey:nil];
            [self.collectionView reloadData];
        }
    }
}

- (void)deleteAction {
    [_indicator startAnimating];
    [[NFSyncManager sharedManager] deleteEventWithSetting:_event];
}

- (void)compliteTaskAction {
    _compliteButton.selected = !_compliteButton.selected;
}

// tag collection view
#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _selectedTags.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NFTagCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"NFTagCell" forIndexPath:indexPath];
    NFValue *val = [self.selectedTags objectAtIndex:indexPath.item];
    [cell addDataToCell:val isEditMode:_isEditing];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [_selectedTags removeObjectAtIndex:indexPath.item];
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NFValue *val = [self.selectedTags objectAtIndex:indexPath.item];
    return [NFTagCell calculateSizeWithValue:val isEditMode:_isEditing];
}

- (CATransition *)swipeTransitionToLeftSide:(BOOL)leftSide
{
    CATransition* transition = [CATransition animation];
    transition.startProgress = 0;
    transition.endProgress = 1.0;
    transition.type = kCATransitionMoveIn;
    transition.subtype = leftSide ? kCATransitionFromRight : kCATransitionFromTop;
    transition.duration = 0.3;
    return transition;
}

- (void)saveChanges {
    if ([_titleOfTaskTextField isValidString] && [_taskDescriptionTextView isValidString]) {
        
        [_indicator startAnimating];
        BOOL newEvent = false;
        if (!_event) {
            _event = [[NFEvent alloc] init];
            newEvent = true;
        }
        [_event.values removeAllObjects];
        _event.values = [NSMutableArray array];
        _selectedTags.count > 0 ? [_event.values addObjectsFromArray:_selectedTags]: nil;
        _event.title = _titleOfTaskTextField.text;
        _event.eventDescription = _taskDescriptionTextView.text;
        _event.isDone = _compliteButton.selected;
        _event.startDate = [self stringDate:_starttextField.text
                                 withFormat:@"LLLL, dd, yyyy HH:mm"
                         dateStringToFromat:@"yyyy-MM-dd'T'HH:mm:ss"];
        _event.endDate = [self stringDate:_endTextField.text
                               withFormat:@"LLLL, dd, yyyy HH:mm"
                       dateStringToFromat:@"yyyy-MM-dd'T'HH:mm:ss"];
        
        if (newEvent) {
            [[NFSyncManager sharedManager] writeNewEventWithSetting:_event];
        } else {
            [[NFSyncManager sharedManager] editEventWithSetting:_event];
        }
    }
}

- (void)endUpdate {
    [_indicator endAnimating];
    [self setPreviewOptions];
    //[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setPreviewOptions {
    [self setStartDataToDisplay];
    self.isEditing = false;
    self.title = @"Задача";
    UIBarButtonItem *rigtButton = [[UIBarButtonItem alloc] initWithTitle:@"Изменить" style:UIBarButtonItemStylePlain target:self action:@selector (setEditOptions)];
    self.navigationItem.rightBarButtonItem = rigtButton;
    [self.navigationItem setLeftButtonType:FHLeftNavigationButtonTypeBack controller:self];
    self.titleOfTaskTextField.userInteractionEnabled = false;
    self.taskDescriptionTextView.userInteractionEnabled = false;
    self.starttextField.userInteractionEnabled = false;
    self.endTextField.userInteractionEnabled = false;
    self.collectionView.userInteractionEnabled = false;
    [self.collectionView.layer addAnimation:[self swipeTransitionToLeftSide:YES ] forKey:nil];
    [self.collectionView reloadData];
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
}

- (void)setEditOptions {
    self.isEditing = true;
    if (_event) {
        self.title = @"Редактирование";
        UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Отмена" style:UIBarButtonItemStylePlain target:self action:@selector (setPreviewOptions)];
        self.navigationItem.leftBarButtonItem = backBarButtonItem;
    } else {
        [self setStartDataToDisplay];
        [self.navigationItem setLeftButtonType:FHLeftNavigationButtonTypeBack controller:self];
    }
    
    UIBarButtonItem *rigtButton = [[UIBarButtonItem alloc] initWithTitle:@"Сохранить" style:UIBarButtonItemStylePlain target:self action:@selector (saveChanges)];
    self.navigationItem.rightBarButtonItem = rigtButton;
    
    self.titleOfTaskTextField.userInteractionEnabled = true;
    self.taskDescriptionTextView.userInteractionEnabled = true;
    self.starttextField.userInteractionEnabled = true;
    self.endTextField.userInteractionEnabled = true;
    self.collectionView.userInteractionEnabled = true;
    [self.collectionView.layer addAnimation:[self swipeTransitionToLeftSide:YES] forKey:nil];
    [self.collectionView reloadData];
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}




@end
