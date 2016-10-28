//
//  FCChatViewController.m
//  FireChat
//
//  Created by soknaly on 10/21/16.
//  Copyright © 2016 Sokna Ly. All rights reserved.
//

#import "FCChatViewController.h"
#import "FCMessagesViewController.h"
#import "FCAddChatViewController.h"

#import "FCChatTableViewCell.h"
#import "FCChat.h"

@interface FCChatViewController () <
UITableViewDelegate,
UITableViewDataSource,
FCAPIServiceDelegate,
FCAddChatViewControllerDelegate
>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<FCChat* > *chats;

@end

@implementation FCChatViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
  [super viewDidLoad];
  [self setupView];
  [self setupData];
}

- (void)setupData {
  self.chats = [NSMutableArray array];
  [[FCAPIService sharedServiced] getChatListForCurrentUserWithDelegate:self];
}

#pragma mark - Views

- (void)setupView {
  [self setupTableView];
}

- (void)setupTableView {
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  self.tableView.tableFooterView = [UIView new];
}

#pragma mark - Actions


- (IBAction)addChatButtonAction:(id)sender {
  FCAddChatViewController *addChatViewController = [FCAddChatViewController viewControllerFromStoryboard];
  addChatViewController.delegate = self;
  UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:addChatViewController];
  navigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
  [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - UITableViewDatasource & Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.chats.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  FCChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[FCChatTableViewCell identifier] forIndexPath:indexPath];
  
  FCChat *chat = self.chats[indexPath.row];
  
  [cell populateWithChat:chat];
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  FCMessagesViewController *messagesViewController = [FCMessagesViewController viewControllerFromStoryboard];
  messagesViewController.chat = self.chats[indexPath.row];
  messagesViewController.hidesBottomBarWhenPushed = YES;
  [self.navigationController pushViewController:messagesViewController animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
  FCChat *chat = self.chats[indexPath.row];
  [[FCAPIService sharedServiced] removeChat:chat];
}

#pragma mark - FCAPIServiceDelegate

- (void)apiService:(FCAPIService *)apiService didAddChat:(FCChat *)chat {
  [self.tableView beginUpdates];
  [self.chats addObject:chat];
  NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:self.chats.count > 1 ?  : self.chats.count - 1 inSection:0];
  [self.tableView insertRowsAtIndexPaths:@[lastIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
  [self.tableView endUpdates];
}

- (void)apiService:(FCAPIService *)apiService didUpdateChat:(FCChat *)chat {
  [self.tableView beginUpdates];
  NSInteger index = [self.chats indexOfObject:chat];
  [self.chats replaceObjectAtIndex:index withObject:chat];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
  [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
  [self.tableView endUpdates];
}

- (void)apiService:(FCAPIService *)apiService didMoveChat:(FCChat *)chat {
  [self.tableView beginUpdates];
  NSInteger index = [self.chats indexOfObject:chat];
  [self.chats removeObjectAtIndex:index];
  [self.chats insertObject:chat atIndex:0];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
  NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
  [self.tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
  [self.tableView endUpdates];
}

- (void)apiService:(FCAPIService *)apiService didRemoveChat:(FCChat *)chat {
  [self.tableView beginUpdates];
  NSInteger index = [self.chats indexOfObject:chat];
  [self.chats removeObject:chat];
  [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
  [self.tableView endUpdates];
}

#pragma mark - FCAddChatViewControllerDelegate

- (void)addChatViewController:(FCAddChatViewController *)chatViewController didAddChat:(FCChat *)chat {
  [chatViewController dismissViewControllerAnimated:YES completion:nil];
  FCMessagesViewController *messagesViewController = [FCMessagesViewController viewControllerFromStoryboard];
  messagesViewController.chat = chat;
  messagesViewController.hidesBottomBarWhenPushed = YES;
  [self.navigationController pushViewController:messagesViewController animated:YES];
}


@end
