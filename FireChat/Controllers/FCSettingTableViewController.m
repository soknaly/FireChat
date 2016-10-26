//
//  FCSettingViewController.m
//  FireChat
//
//  Created by soknaly on 10/21/16.
//  Copyright © 2016 Sokna Ly. All rights reserved.
//

#import "FCSettingTableViewController.h"
#import "FCSettingHeaderView.h"

@interface FCSettingTableViewController ()<
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
FCSettingHeaderViewDelegate
>

@property (nonatomic, strong) FCSettingHeaderView *headerView;

@end

@implementation FCSettingTableViewController

- (FCSettingHeaderView *)headerView {
  if (!_headerView) {
    _headerView = [[[NSBundle mainBundle] loadNibNamed:@"FCSettingHeaderView"
                                                 owner:self
                                               options:nil] firstObject];
    _headerView.delegate = self;
  }
  return _headerView;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self setupView];
}

- (void)setupView {
  [self setupHeaderView];
}

- (void)setupHeaderView {
  FIRUser *currentUser = [[FIRAuth auth] currentUser];
  [self.headerView.profileImageView sd_setImageWithURL:currentUser.photoURL
                                      placeholderImage:[UIImage profilePlaceholderImage]];
  self.tableView.tableHeaderView = self.headerView;
  self.headerView.nameLabel.text = currentUser.displayName;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
  return UIStatusBarStyleLightContent;
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
  
  //TODO: Get image and upload to Firebase
  
}

#pragma mark - UITableViewDelegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 1) {
    [FCAlertController showMessageWithTitle:@"Logout"
                                    message:@"Are you sure you want to logout?"
                           otherButtonTitle:@"Logout"
                           inViewController:self
                         cancleHandlerBlock:nil
                          otherHandlerBlock:^{
                            NSError *error;
                            [[FIRAuth auth] signOut:&error];
                            if (!error) {
                              [self.tabBarController dismissViewControllerAnimated:YES completion:nil];
                            } else {
                              [FCAlertController showErrorWithTitle:@"Logout Failed"
                                                            message:error.localizedDescription
                                                   inViewController:self];
                            }
                            
                          }];
  }
}

#pragma mark - FCSettingHeaderViewDelegate

- (void)settingHeaderViewDidClickProfile:(FCSettingHeaderView *)headerView {
  [FCAlertController showImagePickerInViewController:self
                                            delegate:self];
}

@end
