//
//  FCContactListViewController.m
//  FireChat
//
//  Created by soknaly on 10/22/16.
//  Copyright © 2016 Sokna Ly. All rights reserved.
//

#import "FCContactListViewController.h"
#import "FCContactTableViewCell.h"
#import "FCChat.h"

@interface FCContactListViewController ()<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray<FCChat* > *contacts;

@end

@implementation FCContactListViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self setupView];
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
  NSMutableArray *mutableContact = [NSMutableArray array];
  for (NSDictionary *dict in chatArray) {
    FCChat *contact = [[FCChat alloc] initWithDictionary:dict];
    [mutableContact addObject:contact];
  }
  self.contacts = mutableContact;
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

#pragma mark - Actions 


- (IBAction)dismissButtonAction:(id)sender {
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneButtonAction:(id)sender {
  
}

#pragma mark - UITableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 57;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.contacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  FCContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[FCContactTableViewCell identifier] forIndexPath:indexPath];
  
  FCChat *contact = self.contacts[indexPath.row];
  
  [cell populateWithContact:contact];
  
  return cell;
}

@end
