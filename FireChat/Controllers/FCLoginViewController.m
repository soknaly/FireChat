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
#import "FBSDKLoginKit.h"
#import "FBSDKCoreKit.h"
#import "GoogleSignIn/GoogleSignIn.h"
#import "FCRegisterTableViewController.h"

@interface FCLoginViewController ()<
UITextFieldDelegate,
GIDSignInDelegate,
GIDSignInUIDelegate,
FCRegisterTableViewControllerDelegate
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

- (void)setupController {
  [FCProgressHUD show];
  if ([FIRAuth auth].currentUser) {
    FCTabBarViewController *tabBarController = [FCTabBarViewController viewControllerFromStoryboard];
    tabBarController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:tabBarController animated:YES completion:nil];
  }
  [FCProgressHUD dismiss];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self setupController];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)dealloc {
  [self removeKeyboardNotification];
}

- (void)setupView {
  [GIDSignIn sharedInstance].delegate = self;
  [GIDSignIn sharedInstance].uiDelegate = self;
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
    [[FIRAuth auth] signInWithEmail:self.usernameTextField.text
                           password:self.passwordTextField.text
                         completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
                           [self handleLoginWithUser:user error:error];
                         }];
  }];
}

- (IBAction)facebookButtonAction:(id)sender {
  FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
  [loginManager logInWithReadPermissions:@[@"email",@"public_profile"]
                      fromViewController:self
                                 handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                   if (result.token) {
                                     FIRAuthCredential *authCredential = [FIRFacebookAuthProvider credentialWithAccessToken:result.token.tokenString];
                                     [[FIRAuth auth] signInWithCredential:authCredential
                                                               completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
                                                                 [[FCAPIService sharedServiced] createUserWithID:user.uid
                                                                                                     displayName:user.displayName
                                                                                                    emailAddress:user.email
                                                                                                        photoURL:user.photoURL];
                                                                 [self handleLoginWithUser:user error:error];
                                                               }];
                                   } else {
                                     
                                   }
                                   
                                 }];
}

- (IBAction)googleButtonAction:(id)sender {
  [[GIDSignIn sharedInstance] signIn];
}

- (IBAction)registerButtonAction:(id)sender {
  FCRegisterTableViewController *registerViewController = [FCRegisterTableViewController viewControllerFromStoryboard];
  registerViewController.delegate = self;
  UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:registerViewController];
  navigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
  [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)handleLoginWithUser:(FIRUser *)user
                      error:(NSError *)error {
  if (user && !error) {
    FCTabBarViewController *tabBarController = [FCTabBarViewController viewControllerFromStoryboard];
    tabBarController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:tabBarController animated:YES completion:nil];
    
  } else {
    [FCAlertController showErrorWithTitle:@"Login Failed"
                                  message:error.localizedDescription
                         inViewController:self];
  }
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

#pragma mark - GIDSigninDelegate

- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
  if (!error) {
    FIRAuthCredential *googleCredential = [FIRGoogleAuthProvider credentialWithIDToken:user.authentication.idToken accessToken:user.authentication.accessToken];
    [[FIRAuth auth] signInWithCredential:googleCredential
                              completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
                                [[FCAPIService sharedServiced] createUserWithID:user.uid
                                                                    displayName:user.displayName
                                                                   emailAddress:user.email
                                                                       photoURL:user.photoURL];
                                [self handleLoginWithUser:user
                                                    error:error];
                              }];
  } else {
    [FCAlertController showErrorWithTitle:@"Login Failed"
                                  message:error.localizedDescription
                         inViewController:self];
  }
  
}

#pragma mark - FCRegisterTableViewController

- (void)registerTableViewControllerDidFinishRegister:(FCRegisterTableViewController *)registerTableViewController {
  FCTabBarViewController *tabBarController = [FCTabBarViewController viewControllerFromStoryboard];
  tabBarController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
  [self presentViewController:tabBarController animated:YES completion:nil];
  
}


@end
