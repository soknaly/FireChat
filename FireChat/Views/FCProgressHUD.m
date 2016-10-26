//
//  FCProgressHUD.m
//  FireChat
//
//  Created by soknaly on 10/26/16.
//  Copyright © 2016 Sokna Ly. All rights reserved.
//

#import "FCProgressHUD.h"

@implementation FCProgressHUD

+ (void)show {
  [self setDefaultStyle:SVProgressHUDStyleCustom];
  [self setForegroundColor:[UIColor mainColor]];
  [self setRingThickness:6.0];
  [self setDefaultMaskType:SVProgressHUDMaskTypeBlack];
  [self setBackgroundColor:[UIColor whiteColor]];
  [super show];
}

@end
