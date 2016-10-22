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
}

#pragma mark - Actions

- (void)saveBarButtonItemHandler:(id)sender {
  //TODO: Call firebase code to edit profile
}

@end
