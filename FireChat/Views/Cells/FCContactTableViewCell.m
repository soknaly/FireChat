//
//  FCContactTableViewCell.m
//  FireChat
//
//  Created by soknaly on 10/22/16.
//  Copyright © 2016 Sokna Ly. All rights reserved.
//

#import "FCContactTableViewCell.h"


@interface FCContactTableViewCell ()

@property (nonatomic, weak) IBOutlet UIImageView *profileImageView;

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;

@end

@implementation FCContactTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  if (selected) {
    self.accessoryType = UITableViewCellAccessoryCheckmark;
  } else {
    self.accessoryType = UITableViewCellAccessoryNone;
  }
}

- (void)awakeFromNib {
  [super awakeFromNib];
  self.profileImageView.layer.cornerRadius = CGRectGetWidth(self.profileImageView.frame)/2;
  self.profileImageView.layer.masksToBounds = YES;
}

- (void)populateWithContact:(FCChat *)contact {
  [self.profileImageView sd_setImageWithURL:[contact.recipient photoURL]
                           placeholderImage:[UIImage profilePlaceholderImage]];
  self.nameLabel.text = contact.recipient.displayName;
}


@end
