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

- (void)setupMockData {
  NSArray *chatArray = @[@{@"name":@"Duke",
                           @"lastMessage":@"You: I'm glad to hear that.",
                           @"profileImageUrl":@"https://scontent-hkg3-1.xx.fbcdn.net/v/t1.0-9/14485073_10208554229386265_902072082399694097_n.jpg?oh=2b3d043938c47b7edf48a602147fbd0d&oe=589FB5A9",
                           @"online":@NO},
                         @{@"name":@"Kali Linux",
                           @"lastMessage":@"Alright man! Talk to you later",
                           @"profileImageUrl":@"https://randomuser.me/api/portraits/med/men/84.jpg",
                           @"online":@YES},
                         @{@"name":@"Tony Stark",
                           @"lastMessage":@"Haha sure",
                           @"profileImageUrl":@"https://randomuser.me/api/portraits/med/men/85.jpg",
                           @"online":@YES},
                         @{@"name":@"Jarvis Stark",
                           @"lastMessage":@"I have no idea too dude.",
                           @"profileImageUrl":@"https://randomuser.me/api/portraits/med/men/86.jpg",
                           @"online":@YES},
                         @{@"name":@"Laura Mam",
                           @"lastMessage":@"Which song are going to sing?",
                           @"profileImageUrl":@"https://randomuser.me/api/portraits/med/men/87.jpg",
                           @"online":@NO}];
  NSMutableArray *mutableChat = [NSMutableArray array];
  for (NSDictionary *dict in chatArray) {
    FCChat *chat = [[FCChat alloc] initWithDictionary:dict];
    [mutableChat addObject:chat];
  }
  self.chats = mutableChat;
}

- (void)setupData {
  self.chats = [NSMutableArray array];
  [[FCAPIService sharedServiced] getChatListForCurrentUserWithDelegate:self];
}

#pragma mark - Views

- (void)setupView {
  [self setupTableView];
//  [self setupMockData];
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

#pragma mark - FCAPIServiceDelegate

- (void)apiService:(FCAPIService *)apiService didAddChat:(FCChat *)chat {
  [self.tableView beginUpdates];
  [self.chats addObject:chat];
  NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:self.chats.count > 1 ?  : self.chats.count - 1 inSection:0];
  [self.tableView insertRowsAtIndexPaths:@[lastIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
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
