//
//  FCChatTableViewCell.m
//  FireChat
//
//  Created by soknaly on 10/21/16.
//  Copyright © 2016 Sokna Ly. All rights reserved.
//

#import "FCChatTableViewCell.h"
#import "UIImage+FC.h"

@interface FCChatTableViewCell ()

@property (nonatomic, weak) IBOutlet UIImageView *profileImageView;

@property (nonatomic, weak) IBOutlet UIView *onlineView;

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;

@property (nonatomic, weak) IBOutlet UILabel *lastMessageLabel;

@property (nonatomic, strong) FCChat *chat;

@end

@implementation FCChatTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  self.onlineView.layer.cornerRadius = CGRectGetWidth(self.onlineView.frame)/2;
  self.onlineView.layer.borderColor = [UIColor whiteColor].CGColor;
  self.onlineView.layer.borderWidth = 2;
  self.profileImageView.layer.cornerRadius = CGRectGetWidth(self.profileImageView.frame)/2;
  self.profileImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  if (self.chat) {
//    self.onlineView.backgroundColor = self.chat.isOnline ? [UIColor greenColor] : [UIColor lightGrayColor];
  }
}

- (void)populateWithChat:(FCChat *)chat {
  self.chat = chat;
  [self.profileImageView sd_setImageWithURL:chat.recipient.photoURL
                           placeholderImage:[UIImage profilePlaceholderImage]];
  self.nameLabel.text = chat.recipient.displayName;
  self.lastMessageLabel.text = chat.lastMessage;
//  self.onlineView.backgroundColor = self.chat.isOnline ? [UIColor greenColor] : [UIColor lightGrayColor];
}

@end
