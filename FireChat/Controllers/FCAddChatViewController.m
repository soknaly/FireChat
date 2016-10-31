//
//  FCAddChatViewController.m
//  FireChat
//
//  Created by soknaly on 10/22/16.
//  Copyright © 2016 Sokna Ly. All rights reserved.
//

#import "FCAddChatViewController.h"
#import "FCTextField.h"
#import "FCRoundedButton.h"

@interface FCAddChatViewController () <
UITextFieldDelegate
>

@property (nonatomic, weak) IBOutlet UIButton *searchButton;

@property (nonatomic, weak) IBOutlet FCTextField *usernameTextField;

@property (nonatomic, weak) IBOutlet UIImageView *profileImageView;

@property (nonatomic, weak) IBOutlet UILabel *usernameLabel;

@property (nonatomic, weak) IBOutlet FCRoundedButton *addChatButton;

@property (nonatomic, weak) IBOutlet UIView *profileContainerView;

@property (nonatomic, weak) IBOutlet UILabel *notFoundLabel;

@property (nonatomic, strong) FCUser *user;

@end

@implementation FCAddChatViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.usernameTextField.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self.usernameTextField becomeFirstResponder];
}

#pragma mark - Views

- (void)populateProfileViewWithUser:(FCUser *)user {
  self.user = user;
  BOOL shouldHide = user == nil;
  self.profileContainerView.hidden = shouldHide;
  self.notFoundLabel.hidden = !shouldHide;
  [self.profileImageView sd_setImageWithURL:user.photoURL placeholderImage:[UIImage profilePlaceholderImage]];
  self.usernameLabel.text = user.displayName;
}

#pragma mark - Actions

- (IBAction)dismissButtonAction:(id)sender {
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)usernameTextFieldDidChanged:(UITextField *)textField {
  self.searchButton.enabled = textField.text.length > 0;
}

- (IBAction)searchButtonAction:(id)sender {
  [FCProgressHUD show];
  [[FCAPIService sharedServiced] searchUserWithEmail:self.usernameTextField.text
                                             success:^(FCUser *user) {
                                               [FCProgressHUD dismiss];
                                               [self populateProfileViewWithUser:user];
                                             }
                                             failure:^(NSError *error) {
                                               [FCProgressHUD dismiss];
                                               [FCAlertController showErrorWithTitle:@"Search Failed"
                                                                             message:error.localizedDescription
                                                                    inViewController:self];
                                             }];
}

- (IBAction)addChatButtonAction:(id)sender {
  [[FCAPIService sharedServiced] addChatWithUser:self.user
                                         success:^(FCChat *chat) {
                                           [self.delegate addChatViewController:self didAddChat:chat];
                                         }
                                         failure:^(NSError *error) {
                                           [FCAlertController showErrorWithTitle:@"Add Chat Failed"
                                                                         message:error.localizedDescription
                                                                inViewController:self];
                                         }];
}
#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [self searchButtonAction:self.searchButton];
  return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
  [self populateProfileViewWithUser:nil];
  return YES;
}

@end
