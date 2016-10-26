//
//  FCSettingHeaderView.m
//  FireChat
//
//  Created by soknaly on 10/22/16.
//  Copyright © 2016 Sokna Ly. All rights reserved.
//

#import "FCSettingHeaderView.h"

@interface FCSettingHeaderView ()

@property (nonatomic, weak) IBOutlet UIImageView *profileImageView;

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;

@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

@end

@implementation FCSettingHeaderView

- (UITapGestureRecognizer *)tapGestureRecognizer {
  if (!_tapGestureRecognizer) {
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                    action:@selector(tapGestureRecognizerHandler:)];
    _tapGestureRecognizer.numberOfTapsRequired = 1;
  }
  return _tapGestureRecognizer;
}

- (void)tapGestureRecognizerHandler:(UITapGestureRecognizer *)gesture {
  if ([self.delegate respondsToSelector:@selector(settingHeaderViewDidClickProfile:)]) {
    [self.delegate settingHeaderViewDidClickProfile:self];
  }
}

- (void)awakeFromNib {
  [super awakeFromNib];
  self.profileImageView.userInteractionEnabled = YES;
  self.profileImageView.layer.cornerRadius = CGRectGetWidth(self.profileImageView.frame)/2;
  self.profileImageView.layer.masksToBounds = YES;
  [self.profileImageView addGestureRecognizer:self.tapGestureRecognizer];
}

@end
