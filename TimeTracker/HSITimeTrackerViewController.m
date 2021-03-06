//
//  HSITimeTrackerViewController.m
//  TimeTracker
//
//  Created by Kenny on 6/9/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

#import "HSITimeTrackerViewController.h"
#import "HSITimedTask.h"
#import "HSITimedTaskController.h"

@interface HSITimeTrackerViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

// MARK: Private Properties
@property (nonatomic) HSITimedTask *currentTask;

@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *summaryTextField;
@property (strong, nonatomic) IBOutlet UITextField *hourlyRateTextField;
@property (strong, nonatomic) IBOutlet UITextField *timeWorkedTextField;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (void) updateViews;
- (void) saveTask;

@end

@implementation HSITimeTrackerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nameTextField.delegate = self;
    self.summaryTextField.delegate = self;
    self.hourlyRateTextField.delegate = self;
    self.timeWorkedTextField.delegate = self;

    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    self.taskController = [[HSITimedTaskController alloc] init];
    self.currentTask = [[HSITimedTask alloc] init];
}

- (void)updateViews {
    self.nameTextField.text = @"";
    self.summaryTextField.text = @"";
    self.hourlyRateTextField.text = @"";
    self.timeWorkedTextField.text = @"";

    [self.nameTextField becomeFirstResponder];

    [self.tableView reloadData];
}

- (void) saveTask {
    BOOL emptyFields = [self emptyTextFields];
    if (!emptyFields) {
        double hoursWorked = [self.timeWorkedTextField.text doubleValue]; // BUG: if user doesn't exit last textField, hours don't get saved without this line
        HSITimedTask *task = [[HSITimedTask alloc] initWithClient: self.currentTask.client
                                                          summary: self.currentTask.summary
                                                       hourlyRate: self.currentTask.hourlyRate
                                                      hoursWorked: hoursWorked];
        [self.taskController createTimedTask:task];
        [self updateViews];
    }

}

- (BOOL) emptyTextFields {
    NSString *trimmedName = [self.nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    NSString *trimmedRate = [self.hourlyRateTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    NSString *trimmedHours = [self.timeWorkedTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (![trimmedName isEqualToString: @""] && ![trimmedRate isEqualToString: @""]  && ![trimmedHours isEqualToString: @""]) {
        return NO;
    } else {
        return YES;
    }
}

// MARK: - IBActions -
- (IBAction)createTask:(id)sender {
    [self saveTask];
}

// MARK: - TableView Delegate and DataSource -
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaskCell" forIndexPath:indexPath];
    HSITimedTask *task = [self.taskController.tasks objectAtIndex:indexPath.row];
    cell.textLabel.text = task.client;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f", task.total];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.taskController.tasks.count;
}

// MARK: UITextField Delegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == _nameTextField) {
        self.currentTask.client = self.nameTextField.text;
    }

    else if (textField == self.summaryTextField) {
        self.currentTask.summary = self.summaryTextField.text;
    }

    else if (textField == self.hourlyRateTextField) {
        self.currentTask.hourlyRate = [self.hourlyRateTextField.text doubleValue];
    }

    else if (textField == self.timeWorkedTextField) {
        self.currentTask.hoursWorked = [self.timeWorkedTextField.text doubleValue];
    }
}

@end
