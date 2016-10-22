//
//  FCAddChatViewController.m
//  FireChat
//
//  Created by soknaly on 10/22/16.
//  Copyright © 2016 Sokna Ly. All rights reserved.
//

#import "FCAddChatViewController.h"
#import "FCTextField.h"

@interface FCAddChatViewController ()

@property (nonatomic, weak) IBOutlet UIButton *searchButton;

@property (nonatomic, weak) IBOutlet FCTextField *usernameTextField;

@end

@implementation FCAddChatViewController

- (void)viewDidLoad {
  [super viewDidLoad];
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



@end
