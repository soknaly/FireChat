//
//  FCGroupsViewController.m
//  FireChat
//
//  Created by soknaly on 10/21/16.
//  Copyright © 2016 Sokna Ly. All rights reserved.
//

#import "FCGroupsViewController.h"
#import "FCMessagesViewController.h"
#import "FCContactListViewController.h"
#import "FCGroupTableViewCell.h"
#import "FCGroup.h"

@interface FCGroupsViewController () <
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray<FCGroup *>* groups;

@end

@implementation FCGroupsViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self setupView];
}

#pragma mark - Views

- (void)setupView {
  [self setupTableView];
  [self setupMockData];
}

- (void)setupTableView {
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  self.tableView.tableFooterView = [UIView new];
}

- (void)setupMockData {
  NSArray<NSDictionary<NSString *,NSString *>*>* groups = @[@{@"name":@"GDG DevFest",
                                                              @"lastMessage":@"Build iOS Chat App with Firebase",
                                                              @"lastMessageSenderName":@"Sokna Ly"},
                                                            @{@"name":@"BFFs",
                                                              @"lastMessage":@"Let's meet at CKCC then",
                                                              @"lastMessageSenderName":@"Ah Songha"},
                                                            @{@"name":@"Family",
                                                              @"lastMessage":@"I will call you soon.",
                                                              @"lastMessageSenderName":@"Mom"},
                                                            @{@"name":@"Genius Devs",
                                                              @"lastMessage":@"I'm going to have a commit soon.",
                                                              @"lastMessageSenderName":@"Komsann Ly"}];
  NSMutableArray *mutableGroup = [NSMutableArray array];
  [groups enumerateObjectsUsingBlock:^(NSDictionary<NSString *,NSString *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    FCGroup *group = [[FCGroup alloc] initWithDictionary:obj];
    [mutableGroup addObject:group];
  }];
  self.groups = mutableGroup;
}


- (IBAction)addButtonAction:(id)sender {
  UIAlertController *createGroupAlertController = [UIAlertController alertControllerWithTitle:@"Create Group"
                                                                                      message:nil
                                                                               preferredStyle:UIAlertControllerStyleAlert];
  [createGroupAlertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
    textField.placeholder = @"Group Name";
  }];
  UIAlertAction *createAction = [UIAlertAction actionWithTitle:@"Create"
                                                         style:UIAlertActionStyleDestructive
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                         FCContactListViewController *contactViewController = [FCContactListViewController viewControllerFromStoryboard];
                                                         UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:contactViewController];
                                                         [self presentViewController:navigationController animated:YES completion:nil];
                                                       }];
  
  UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                         style:UIAlertActionStyleCancel
                                                       handler:nil];
  
  [createGroupAlertController addAction:cancelAction];
  [createGroupAlertController addAction:createAction];
  [self presentViewController:createGroupAlertController animated:YES completion:nil];
}


#pragma mark - UITableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 67;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.groups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  FCGroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[FCGroupTableViewCell identifier] forIndexPath:indexPath];
  
  FCGroup *group = self.groups[indexPath.row];
  
  [cell populateWithGroup:group];
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  FCMessagesViewController *messagesViewController = [FCMessagesViewController viewControllerFromStoryboard];
  //  messagesViewController.chat = self.groups[indexPath.row];
  messagesViewController.hidesBottomBarWhenPushed = YES;
  [self.navigationController pushViewController:messagesViewController animated:YES];
}
@end
