//
//  FCLoginViewController.m
//  FireChat
//
//  Created by soknaly on 10/21/16.
//  Copyright © 2016 Sokna Ly. All rights reserved.
//

#import "FCLoginViewController.h"
#import "FCTextField.h"
#import "FCRoundedButton.h"
#import "FCTabBarViewController.h"

@interface FCLoginViewController ()<
UITextFieldDelegate
>

@property (nonatomic, weak) IBOutlet FCTextField *usernameTextField;

@property (nonatomic, weak) IBOutlet FCTextField *passwordTextField;

@property (nonatomic, weak) IBOutlet FCRoundedButton *loginButton;

@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *loadingButtonIndicatorView;

@property (nonatomic, weak) IBOutlet UIView *containerView;

@end

@implementation FCLoginViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self setupView];
  [self registerKeyboardNotifications];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)dealloc {
  [self removeKeyboardNotification];
}

- (void)setupView {
  self.usernameTextField.delegate = self;
  self.passwordTextField.delegate = self;
}

- (void)registerKeyboardNotifications {
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeKeyboardNotification {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Validation

- (void)validateLoginWithCompletion:(void(^)())completion {
  NSString *message = nil;
  if ([self.usernameTextField.text isEmpty]) {
    message = @"Please input your email!";
    [self.usernameTextField becomeFirstResponder];
  } else {
    if (![self.usernameTextField.text isValidEmail]) {
      message = @"Please input valid email!";
      [self.usernameTextField becomeFirstResponder];
    }
  }
  
  if ([self.passwordTextField.text isEmpty]) {
    message = @"Please input your password!";
    [self.passwordTextField becomeFirstResponder];
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

- (IBAction)loginButtonAction:(id)sender {
  [self validateLoginWithCompletion:^{
    //TODO: Login with Firebase here
    [[FIRAuth auth] signInWithEmail:self.usernameTextField.text
                           password:self.passwordTextField.text completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
                             if (user && !error) {
                               FCTabBarViewController *tabBarController = [FCTabBarViewController viewControllerFromStoryboard];
                               tabBarController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                               [self presentViewController:tabBarController animated:YES completion:nil];
                               
                             } else {
                               [FCAlertController showErrorWithTitle:@"Login Failed"
                                                             message:error.localizedDescription
                                                    inViewController:self];
                             }
                           }];
  }];
}

- (IBAction)facebookButtonAction:(id)sender {
  
}

- (IBAction)twitterButtonAction:(id)sender {
  
}

- (IBAction)googleButtonAction:(id)sender {
  
}

- (IBAction)registerButtonAction:(id)sender {
  
}

#pragma mark - Touch

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  if ([textField isEqual:self.usernameTextField]) {
    [self.passwordTextField becomeFirstResponder];
  } else {
    if ([self.usernameTextField.text isEmpty]) {
      [self.usernameTextField becomeFirstResponder];
    } else {
      [self loginButtonAction:self.loginButton];
    }
  }
  return YES;
}

#pragma mark - Notifications

- (void)keyboardWillShow:(NSNotification *)notification {
  NSDictionary *userInfo = [notification userInfo];
  
  CGRect keyboardEndFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
  
  if (CGRectIsNull(keyboardEndFrame)) {
    return;
  }
  
  UIViewAnimationCurve animationCurve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
  NSInteger animationCurveOption = (animationCurve << 16);
  
  double animationDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
  
  
  CGFloat screenHeight = CGRectGetHeight([UIScreen mainScreen].bounds);
  
  CGFloat loginButtonMaximumY = CGRectGetMaxY(self.containerView.frame);
  
  CGFloat bottomSpace = screenHeight - loginButtonMaximumY;
  
  CGFloat keyboardHeight = CGRectGetHeight(keyboardEndFrame);
  
  if (keyboardHeight > bottomSpace) {
    CGFloat moveToY = keyboardHeight - bottomSpace + 25;
    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:animationCurveOption
                     animations:^{
                       self.view.transform = CGAffineTransformMakeTranslation(0, -moveToY);
                     }
                     completion:nil];
  }
}

- (void)keyboardWillHide:(NSNotification *)notification {
  NSDictionary *userInfo = [notification userInfo];
  
  UIViewAnimationCurve animationCurve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
  NSInteger animationCurveOption = (animationCurve << 16);
  
  double animationDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
  [UIView animateWithDuration:animationDuration
                        delay:0.0
                      options:animationCurveOption
                   animations:^{
                     self.view.transform = CGAffineTransformIdentity;
                   }
                   completion:nil];
  
}

@end
