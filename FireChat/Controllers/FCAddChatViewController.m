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

#pragma mark - Actions

- (IBAction)dismissButtonAction:(id)sender {
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)usernameTextFieldDidChanged:(UITextField *)textField {
  self.searchButton.enabled = textField.text.length > 0;
}

- (IBAction)searchButtonAction:(id)sender {
  
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [self searchButtonAction:self.searchButton];
  return YES;
}


@end
