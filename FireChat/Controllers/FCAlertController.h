//
//  FCAlertViewController.h
//  FireChat
//
//  Created by soknaly on 10/22/16.
//  Copyright © 2016 Sokna Ly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FCAlertController : UIAlertController

+ (void)showErrorWithTitle:(NSString *)title
                   message:(NSString *)message
          inViewController:(UIViewController *)controller;

+ (void)showErrorWithTitle:(NSString *)title
                   message:(NSString *)message
          inViewController:(UIViewController *)controller
              handlerBlock:(void(^)())handler;

+ (void)showMessageWithTitle:(NSString *)title
                     message:(NSString *)message
            otherButtonTitle:(NSString *)otherButtonTitle
            inViewController:(UIViewController *)controller
          cancleHandlerBlock:(void(^)())cancleHandler
           otherHandlerBlock:(void(^)())handler;

+ (void)showImagePickerInViewController:(UIViewController *)viewController
                               delegate:(id<UIImagePickerControllerDelegate, UINavigationControllerDelegate>)delegate;


@end
