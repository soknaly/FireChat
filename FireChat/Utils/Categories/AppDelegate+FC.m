//
//  AppDelegate+FC.m
//  FireChat
//
//  Created by soknaly on 10/21/16.
//  Copyright © 2016 Sokna Ly. All rights reserved.
//

#import "AppDelegate+FC.h"

@implementation AppDelegate (FC)

- (void)setupAppearance {
  [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
  [[UINavigationBar appearance] setBarTintColor:[UIColor mainColor]];
  [[UINavigationBar appearance] setTranslucent:NO];
  [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
}

@end
