//
//  FCEditProfileTableViewController.m
//  FireChat
//
//  Created by soknaly on 10/22/16.
//  Copyright © 2016 Sokna Ly. All rights reserved.
//

#import "FCEditProfileTableViewController.h"

@interface FCEditProfileTableViewController ()

@property (nonatomic, strong) UIBarButtonItem *saveBarButtonItem;
@property (nonatomic, weak) IBOutlet UITextField *firstNameTextField;
@property (nonatomic, weak) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailAddressTextField;

@end

@implementation FCEditProfileTableViewController

- (UIBarButtonItem *)saveBarButtonItem {
  if (!_saveBarButtonItem) {
    _saveBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save"
                                                          style:UIBarButtonItemStyleDone
                                                         target:self
                                                         action:@selector(saveBarButtonItemHandler:)];
  }
  return _saveBarButtonItem;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self setupView];
}

- (void)setupView {
  self.title = @"Edit Profile";
  self.navigationItem.rightBarButtonItem = self.saveBarButtonItem;
  FIRUser *currentUser = [FIRAuth auth].currentUser;
  NSArray *names = [currentUser.displayName componentsSeparatedByString:@" "];
  NSString *firstName = names.firstObject;
  NSString *lastName = names.lastObject;
  self.firstNameTextField.text = firstName;
  self.lastNameTextField.text = lastName;
  self.emailAddressTextField.text = currentUser.email;
}

#pragma mark - Validation

- (void)validateEditProfileWithCompletion:(void(^)())completion {
  NSString *message = nil;
  if ([self.firstNameTextField.text isEmpty]) {
    message = @"Please input your first name!";
    [self.firstNameTextField becomeFirstResponder];
  }  else if ([self.lastNameTextField.text isEmpty]) {
    message = @"Please input your last name!";
    [self.lastNameTextField becomeFirstResponder];
  } else if ([self.emailAddressTextField.text isEmpty]) {
    message = @"Please input your email!";
    [self.emailAddressTextField becomeFirstResponder];
  } else {
    if (![self.emailAddressTextField.text isValidEmail]) {
      message = @"Please input your valid email!";
      [self.emailAddressTextField becomeFirstResponder];
    }
  }
  if (message) {
    [FCAlertController showErrorWithTitle:@"Edit Profile Failed"
                                  message:message
                         inViewController:self];
  } else {
    completion();
  }
}

#pragma mark - Actions

- (void)saveBarButtonItemHandler:(id)sender {
  [self validateEditProfileWithCompletion:^{
    [FCProgressHUD show];
    [[FCAPIService sharedServiced] updateCurrentUserWithFirstName:self.firstNameTextField.text
                                                         lastName:self.lastNameTextField.text
                                                            email:self.emailAddressTextField.text
                                                          success:^{
                                                            [FCProgressHUD dismiss];
                                                            [FCAlertController showErrorWithTitle:@"Edit Profile Successfully"
                                                                                          message:@"Your Profile has been edited"
                                                                                 inViewController:self
                                                                                     handlerBlock:^{
                                                                                       [self.navigationController popViewControllerAnimated:YES];
                                                                                     }];
                                                          }
                                                          failure:^(NSError *error) {
                                                            [FCProgressHUD dismiss];
                                                            [FCAlertController showErrorWithTitle:@"Edit Profile Failed"
                                                                                          message:error.localizedDescription
                                                                                 inViewController:self];
                                                          }];
  }];
}

@end
