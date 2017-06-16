//
//  NFValueController.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 6/8/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFValueController.h"
#import "NFTaskManager.h"
#import "NFValue.h"
#import "NFValueCell.h"
#import "NFSyncManager.h"
#import "NFStyleKit.h"
#import "NFActivityIndicatorView.h"
#import "TPKeyboardAvoidingTableView.h"


@interface NFValueController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingTableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableArray *deletedValues;
@property (strong, nonatomic) NFActivityIndicatorView *indicator;


@end

@implementation NFValueController

- (void)viewDidLoad {
    [super viewDidLoad];
    _deletedValues = [NSMutableArray array];
    self.title = @"Мои ценности";
    [self addNavigationButtons];
    _indicator = [[NFActivityIndicatorView alloc] initWithView:self.view];
    [self.tableView registerNib:[UINib nibWithNibName:@"NFValueCell" bundle:nil] forCellReuseIdentifier:@"NFValueCell"];
    [NFStyleKit foterViewWithAddTextFieldtoTableView:_tableView withTarget:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endUpdate) name:END_UPDATE_DATA object:nil];

    [self addDataToDisplay];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:END_UPDATE_DATA object:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NFValueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NFValueCell"];
    cell.showsReorderControl = YES;
    NFValue *value = [_dataArray objectAtIndex:indexPath.row];
    [cell addData:value];
    return cell;
}


#pragma mark - UITableViewDelegate


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_deletedValues addObject:[_dataArray objectAtIndex:indexPath.row]];
        [_dataArray removeObjectAtIndex:indexPath.row];
        if (_dataArray.count > 0) {
            [self.tableView beginUpdates];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
        } else {
            [_tableView reloadData];
        }
    }
}

- (BOOL) tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void) tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    NSInteger sourceRow = sourceIndexPath.row;
    NSInteger destRow = destinationIndexPath.row;
    id object = [_dataArray objectAtIndex:sourceRow];
    
    [_dataArray removeObjectAtIndex:sourceRow];
    [_dataArray insertObject:object atIndex:destRow];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"text field text %@ end!!!",textField.text);
    [textField resignFirstResponder];
    [self addNewValueWithName:textField.text andIndex:_dataArray.count];
    textField.text = @"";
    return YES;
}

#pragma mark - Helpers

- (IBAction) editButtonAction:(id)sender{
    [_tableView setEditing:!_tableView.editing animated:YES];
    
    if (_tableView.editing) {
        [self.navigationItem.rightBarButtonItem setTitle:@"Готово"];
        [self addCancelButton];
    } else {
        [self.navigationItem.rightBarButtonItem setTitle:@"Изменить"];
        [self saveChanges];
        [self addNavigationButton];
    }
}

- (void)addDataToDisplay {
    self.dataArray = [NSMutableArray array];
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:[[NFTaskManager sharedManager] getAllValues]];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)exitAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancelAction {
    [_tableView setEditing:NO animated:YES];
    [self addNavigationButton];
    [self.navigationItem.rightBarButtonItem setTitle:@"Изменить"];
    [self addDataToDisplay];
}

- (void)addNavigationButtons {
    [self addNavigationButton];
    
    UIBarButtonItem *rigtButton = [[UIBarButtonItem alloc] initWithTitle:@"Изменить" style:UIBarButtonItemStylePlain target:self action:@selector (editButtonAction:)];
    self.navigationItem.rightBarButtonItem = rigtButton;
}

- (void)addNavigationButton {
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back_standart"] style:UIBarButtonItemStylePlain target:self action:@selector(exitAction)];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
}

- (void)addCancelButton {
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Отмена"  style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];
    self.navigationItem.leftBarButtonItem = cancelButton;
}

- (void)saveChanges {
    [_indicator startAnimating];
    NSLog(@"Save Changes in Value list 😎");
    if (_deletedValues.count > 0) {
        for (NFValue *val in _deletedValues) {
            [[NFSyncManager sharedManager] deleteValueFromFirebase:val];
        }
        [_deletedValues removeAllObjects];
    }
    
    NSMutableArray *newArray = [NSMutableArray array];
    [newArray addObjectsFromArray:[self updateIndexInValuesArray:_dataArray]];
    [self saveValuesArrayToDataBase:newArray];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[NFSyncManager sharedManager]  updateAllData];
    });
}

- (void)endUpdate {
    [_indicator endAnimating];
    [self addDataToDisplay];
}

- (NSMutableArray *)updateIndexInValuesArray:(NSMutableArray*)inputArray {
    NSMutableArray *result = [NSMutableArray array];
    for (int i = 0; i < inputArray.count; i++) {
        NFValue *val = [inputArray objectAtIndex:i];
        val.valueIndex = [NSNumber numberWithInt:i];
        [result addObject:val];
    }
    return result;
}

- (void)saveValuesArrayToDataBase:(NSMutableArray*)array {
    for (NFValue *val in array) {
        [[NFSyncManager sharedManager] writeValueToFirebase:val];
    }
}

- (void)addValueAction:(UIButton*)sender {
    NSLog(@"+ add action pressed");
}

- (void)addNewValueWithName:(NSString*)value andIndex:(NSInteger)index {
    if (value.length > 0) {
        [_indicator startAnimating];
        NFValue *newValue = [[NFValue alloc] init];
        newValue.valueTitle = value;
        newValue.valueIndex = [NSNumber numberWithInteger:index];
        [[NFSyncManager sharedManager] writeValueToFirebase:newValue];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NFSyncManager sharedManager]  updateAllData];
        });
    }
}

@end
