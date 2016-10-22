//
//  FCAlertViewController.m
//  FireChat
//
//  Created by soknaly on 10/22/16.
//  Copyright © 2016 Sokna Ly. All rights reserved.
//

#import "FCAlertController.h"

@interface FCAlertController ()

@end

@implementation FCAlertController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.tintColor = [UIColor mainColor];
}

+ (void)showErrorWithTitle:(NSString *)title
                   message:(NSString *)message
          inViewController:(UIViewController *)controller {
  
  [self showErrorWithTitle:title
                   message:message
          inViewController:controller
              handlerBlock:nil];
  
}

+ (void)showErrorWithTitle:(NSString *)title
                   message:(NSString *)message
          inViewController:(UIViewController *)controller
              handlerBlock:(void (^)())handler {
  
  FCAlertController *alertViewController = [FCAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
  UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Ok"
                                                         style:UIAlertActionStyleCancel
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                         if (handler) handler();
                                                       }];
  [alertViewController addAction:cancelAction];
  [controller presentViewController:alertViewController animated:YES completion:nil];
  
}

+ (void)showMessageWithTitle:(NSString *)title
                     message:(NSString *)message
            otherButtonTitle:(NSString *)otherButtonTitle
            inViewController:(UIViewController *)controller
          cancleHandlerBlock:(void (^)())cancleHandler
           otherHandlerBlock:(void (^)())handler {
  
  FCAlertController *alertViewController = [FCAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
  
  UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                         style:UIAlertActionStyleCancel
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                         if (cancleHandler) cancleHandler();
                                                       }];
  
  UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle
                                                        style:UIAlertActionStyleDestructive
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                        if (handler) handler();
                                                      }];
  [alertViewController addAction:cancelAction];
  [alertViewController addAction:otherAction];
  [controller presentViewController:alertViewController animated:YES completion:nil];
}

+ (void)showImagePickerInViewController:(UIViewController *)viewController delegate:(id<UIImagePickerControllerDelegate,UINavigationControllerDelegate>)delegate {
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Upload Photo"
                                                                           message:nil
                                                                    preferredStyle:UIAlertControllerStyleActionSheet];
  UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
  imagePickerController.allowsEditing = YES;
  imagePickerController.delegate = delegate;
  UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"Take Photo"
                                                            style:UIAlertActionStyleDestructive
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                                                            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                                                              imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                                                              [viewController presentViewController:imagePickerController animated:YES completion:nil];
                                                            } else {
                                                              [self showErrorWithTitle:@"Error"
                                                                                            message:@"Camera not available on this device."
                                                                                   inViewController:viewController];
                                                              return;
                                                            }
                                                          }];
  UIAlertAction *choosePhotoAction = [UIAlertAction actionWithTitle:@"Choose from Library"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * _Nonnull action) {
                                                              imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                                              [viewController presentViewController:imagePickerController animated:YES completion:nil];
                                                            }];
  UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                         style:UIAlertActionStyleCancel
                                                       handler:nil];
  [alertController addAction:choosePhotoAction];
  [alertController addAction:takePhotoAction];
  [alertController addAction:cancelAction];
  [viewController presentViewController:alertController animated:YES completion:nil];
}


@end
