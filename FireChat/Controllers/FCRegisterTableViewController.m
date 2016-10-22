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
UIImagePickerControllerDelegate
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
  self.lastNameTextField.hasBottomLine = YES;
  self.emailAddressTextField.hasBottomLine = YES;
  self.passwordTextField.hasBottomLine = YES;
  self.confirmPasswordTextField.hasBottomLine = YES;
  self.profileImageView.layer.cornerRadius = CGRectGetWidth(self.profileImageView.frame)/2;
  self.profileImageView.layer.masksToBounds = YES;
}

#pragma mark - Actions

- (IBAction)dismissButtonAction:(id)sender {
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)createAccountButtonAction:(id)sender {
  //TODO: Register account to firebase
}

- (IBAction)profileImageGestureHandler:(UITapGestureRecognizer *)sender {
  [FCAlertController showImagePickerInViewController:self
                                            delegate:self];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
  self.profileImage = info[UIImagePickerControllerEditedImage];
  self.profileImageView.image = self.profileImage;
  [picker dismissViewControllerAnimated:YES completion:nil];
}


@end
