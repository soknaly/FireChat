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
  [picker dismissViewControllerAnimated:YES completion:nil];
  //TODO: Call API to upload image and update profile
  
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
                            //TODO: Call sending offline status
                            //TODO: Call singout
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  if (section == 0) {
    return 90;
  }
  return 10;
}

#pragma mark - FCSettingHeaderViewDelegate

- (void)settingHeaderViewDidClickProfile:(FCSettingHeaderView *)headerView {
  [FCAlertController showImagePickerInViewController:self
                                            delegate:self];
}

@end
