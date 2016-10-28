//
//  FCChangePasswordTableViewController.m
//  FireChat
//
//  Created by soknaly on 10/22/16.
//  Copyright © 2016 Sokna Ly. All rights reserved.
//

#import "FCChangePasswordTableViewController.h"

@interface FCChangePasswordTableViewController ()

@property (nonatomic, strong) UIBarButtonItem *saveBarButtonItem;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;
@property (nonatomic, weak) IBOutlet UITextField *confirmPasswordTextField;

@end

@implementation FCChangePasswordTableViewController

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
  self.title = @"Change Password";
  self.navigationItem.rightBarButtonItem = self.saveBarButtonItem;
}

#pragma mark - Validation


- (void)validateChangePassword:(void(^)())success {
  NSString *message = nil;
  if ([self.passwordTextField.text isEmpty]) {
    message = @"Please input your new password";
    [self.passwordTextField becomeFirstResponder];
  } else if ([self.confirmPasswordTextField.text isEmpty]) {
    message = @"Please input your confirm password";
    [self.confirmPasswordTextField becomeFirstResponder];
  } else if ([self.passwordTextField.text isEqualToString:self.confirmPasswordTextField.text]) {
    message = @"Both password do not match!";
    [self.passwordTextField becomeFirstResponder];
  } else {
    success();
  }
}

#pragma mark - Actions

- (void)saveBarButtonItemHandler:(id)sender {
  [self validateChangePassword:^{
    FIRUser *currentUser = [FIRAuth auth].currentUser;
    [FCProgressHUD show];
    [currentUser updatePassword:self.passwordTextField.text completion:^(NSError * _Nullable error) {
      [FCProgressHUD dismiss];
      if (error) {
        [FCAlertController showErrorWithTitle:@"Change Password Failed"
                                      message:error.localizedDescription
                             inViewController:self];
      } else {
        [FCAlertController showErrorWithTitle:@"Change Password Succeeded"
                                      message:@"Your password has been changed successfully."
                             inViewController:self handlerBlock:^{
                               [self.navigationController popViewControllerAnimated:YES];
                             }];
      }
    }];

  }];
}

@end
