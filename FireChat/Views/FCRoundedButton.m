//
//  FCRoundedButton.m
//  FireChat
//
//  Created by soknaly on 10/21/16.
//  Copyright © 2016 Sokna Ly. All rights reserved.
//

#import "FCRoundedButton.h"

@implementation FCRoundedButton

- (instancetype)init {
  self = [super init];
  if (self) {
    [self setupView];
  }
  return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self setupView];
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
  self = [super initWithCoder:coder];
  if (self) {
    [self setupView];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  [self setupView];
}

- (void)setupView {
  self.layer.cornerRadius = self.bounds.size.height/2;
}

@end
