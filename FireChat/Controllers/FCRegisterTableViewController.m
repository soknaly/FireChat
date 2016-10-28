//
//  FCRegisterTableViewController.m
//  FireChat
//
//  Created by soknaly on 10/22/16.
//  Copyright © 2016 Sokna Ly. All rights reserved.
//

#import "FCRegisterTableViewController.h"
#import "FCRoundedButton.h"
#import "FCTextField.h"

@interface FCRegisterTableViewController ()<
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
UITextFieldDelegate
>

@property (nonatomic, weak) IBOutlet FCRoundedButton *createAccountButton;
@property (nonatomic, weak) IBOutlet UIImageView *profileImageView;
@property (nonatomic, weak) IBOutlet FCTextField *firstNameTextField;
@property (nonatomic, weak) IBOutlet FCTextField *lastNameTextField;
@property (nonatomic, weak) IBOutlet FCTextField *emailAddressTextField;
@property (nonatomic, weak) IBOutlet FCTextField *passwordTextField;
@property (nonatomic, weak) IBOutlet FCTextField *confirmPasswordTextField;

@property (nonatomic, strong) UIImage *profileImage;
@end

@implementation FCRegisterTableViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
  [super viewDidLoad];
  [self setupView];
}

#pragma mark - Views

- (void)setupView {
  self.firstNameTextField.hasBottomLine = YES;
  self.firstNameTextField.delegate = self;
  self.lastNameTextField.hasBottomLine = YES;
  self.lastNameTextField.delegate = self;
  self.emailAddressTextField.hasBottomLine = YES;
  self.emailAddressTextField.delegate = self;
  self.passwordTextField.hasBottomLine = YES;
  self.passwordTextField.delegate = self;
  self.confirmPasswordTextField.hasBottomLine = YES;
  self.confirmPasswordTextField.delegate = self;
  self.profileImageView.layer.cornerRadius = CGRectGetWidth(self.profileImageView.frame)/2;
  self.profileImageView.layer.masksToBounds = YES;
}

#pragma mark - Validation

- (void)validateRegisterWithCompletion:(void(^)())completion {
  NSString *message = nil;
  if ([self.firstNameTextField.text isEmpty]) {
    message = @"Please input your first name!";
    [self.firstNameTextField becomeFirstResponder];
  } else if([self.lastNameTextField.text isEmpty]) {
    message = @"Please input your last name!";
    [self.lastNameTextField becomeFirstResponder];
  } else if ([self.emailAddressTextField.text isEmpty]) {
    message = @"Please input your email!";
    [self.emailAddressTextField becomeFirstResponder];
  } else if([self.passwordTextField.text isEmpty]) {
    message = @"Please input your password!";
    [self.passwordTextField becomeFirstResponder];
  } else if([self.confirmPasswordTextField.text isEmpty]) {
    message = @"Please input your confirm password!";
    [self.confirmPasswordTextField becomeFirstResponder];
  } else {
    if (![self.emailAddressTextField.text isValidEmail]) {
      message = @"Please input valid email!";
      [self.emailAddressTextField becomeFirstResponder];
    } else if (![self.passwordTextField.text isEqualToString:self.confirmPasswordTextField.text]) {
      message = @"Both password do not match!";
      [self.confirmPasswordTextField becomeFirstResponder];
    }
  }
  
  if (message) {
    [FCAlertController showErrorWithTitle:@"Login Failed"
                                  message:message
                         inViewController:self];
    
  } else {
    completion();
  }
}

#pragma mark - Actions

- (IBAction)dismissButtonAction:(id)sender {
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)createAccountButtonAction:(id)sender {
  [self validateRegisterWithCompletion:^{
    //TODO: Call API to register
  }];
  
}

- (IBAction)profileImageGestureHandler:(UITapGestureRecognizer *)sender {
  [FCAlertController showImagePickerInViewController:self
                                            delegate:self];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  NSArray<UITextField *>* textFields = @[self.firstNameTextField,
                                             self.lastNameTextField,
                                             self.emailAddressTextField,
                                             self.passwordTextField,
                                             self.confirmPasswordTextField];
  [textFields enumerateObjectsUsingBlock:^(UITextField * _Nonnull textField, NSUInteger idx, BOOL * _Nonnull stop) {
    BOOL missing = NO;
    if ([textField.text isEmpty]) {
      [textField becomeFirstResponder];
      missing = YES;
      *stop = YES;
    }
    if (!missing && (idx == textFields.count - 1)) {
      [self createAccountButtonAction:self.createAccountButton];
    }
  }];
  return YES;
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
  self.profileImage = info[UIImagePickerControllerEditedImage];
  self.profileImageView.image = self.profileImage;
  [picker dismissViewControllerAnimated:YES completion:nil];
}


@end
