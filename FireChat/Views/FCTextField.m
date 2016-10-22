//
//  FCTextField.m
//  FireChat
//
//  Created by soknaly on 10/21/16.
//  Copyright © 2016 Sokna Ly. All rights reserved.
//

#import "FCTextField.h"

@interface FCTextField ()

@property (nonatomic, strong) CALayer *bottomLineLayer;

@end

@implementation FCTextField

- (CALayer *)bottomLineLayer {
  if (!_bottomLineLayer) {
    _bottomLineLayer = [CALayer layer];
    _bottomLineLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
  }
  return _bottomLineLayer;
}

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

- (void)setupView {
  self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
}

- (void)setLeftImage:(UIImage *)leftImage {
  UIImageView *imageView = [[UIImageView alloc] init];
  imageView.frame = CGRectMake(0, 0, 20, 20);
  imageView.image = leftImage;
  self.leftViewMode = UITextFieldViewModeAlways;
  self.clipsToBounds = YES;
  self.leftView = imageView;
}

- (CGRect)leftViewRectForBounds:(CGRect)bounds {
  CGRect textRect = [super leftViewRectForBounds:bounds];
  textRect.origin.x += 5;
  return textRect;
}


- (void)setHasBottomLine:(BOOL)hasBottomLine {
  _hasBottomLine = hasBottomLine;
  [self setNeedsUpdateConstraints];
  [self setNeedsLayout];
  [self layoutIfNeeded];
  if (_hasBottomLine) {
    CGRect layerFrame = CGRectMake(0.0f, self.frame.size.height - 0.5, self.frame.size.width, 0.5f);
    layerFrame.size.width = CGRectGetWidth(self.bounds);
    self.bottomLineLayer.frame = layerFrame;
    [self.layer addSublayer:self.bottomLineLayer];
  } else {
    [self.bottomLineLayer removeFromSuperlayer];
  }
}

@end
