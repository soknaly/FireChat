//
//  FCGroupTableViewCell.m
//  FireChat
//
//  Created by soknaly on 10/22/16.
//  Copyright © 2016 Sokna Ly. All rights reserved.
//

#import "FCGroupTableViewCell.h"

@interface FCGroupTableViewCell ()

@property (nonatomic, weak) IBOutlet UIImageView *profileImageView;

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;

@property (nonatomic, weak) IBOutlet UILabel *lastMessageLabel;

@end

@implementation FCGroupTableViewCell

- (void)populateWithGroup:(FCGroup *)group {
  
  self.nameLabel.text = group.name;
  self.lastMessageLabel.text = [NSString stringWithFormat:@"%@: %@", group.lastMessageSenderName, group.lastMessage];
  
}


@end
