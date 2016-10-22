//
//  UIViewController+FC.m
//  FireChat
//
//  Created by soknaly on 10/21/16.
//  Copyright © 2016 Sokna Ly. All rights reserved.
//

#import "UIViewController+FC.h"

@implementation UIViewController (FC)

+ (instancetype)viewControllerFromStoryboard {
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                       bundle:[NSBundle mainBundle]];
  UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
  return viewController;
}

@end
