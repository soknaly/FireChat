//
//  AppDelegate.m
//  FireChat
//
//  Created by soknaly on 10/16/16.
//  Copyright © 2016 Sokna Ly. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+FC.h"
#import "FBSDKCoreKit.h"
#import "GoogleSignIn/GoogleSignIn.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [self setupAppearance];
  [FIRApp configure];
  [GIDSignIn sharedInstance].clientID = [FIRApp defaultApp].options.clientID;
  [[FBSDKApplicationDelegate sharedInstance] application:application
                           didFinishLaunchingWithOptions:launchOptions];
  return YES;
}

- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<NSString *,id> *)options {
  
  BOOL facebookHandled = [[FBSDKApplicationDelegate sharedInstance] application:app
                                                                openURL:url
                                                      sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                             annotation:options[UIApplicationOpenURLOptionsAnnotationKey]
                  ];
  
  BOOL googleHandled = [[GIDSignIn sharedInstance] handleURL:url
                                           sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                  annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
  return facebookHandled || googleHandled;

}

@end
