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

@interface FCLoginViewController ()

@property (nonatomic, weak) IBOutlet FCTextField *usernameTextField;

@property (nonatomic, weak) IBOutlet FCTextField *passwordTextField;

@property (nonatomic, weak) IBOutlet FCRoundedButton *loginButton;

@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *loadingButtonIndicatorView;

@property (nonatomic, weak) IBOutlet UIView *containerView;

@end

@implementation FCLoginViewController

- (void)viewDidLoad {
  [super viewDidLoad];
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

- (void)registerKeyboardNotifications {
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeKeyboardNotification {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)loginButtonAction:(id)sender {
  
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
