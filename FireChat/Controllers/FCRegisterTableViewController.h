//
//  FCRegisterTableViewController.h
//  FireChat
//
//  Created by soknaly on 10/22/16.
//  Copyright © 2016 Sokna Ly. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FCRegisterTableViewController;

@protocol FCRegisterTableViewControllerDelegate <NSObject>

- (void)registerTableViewControllerDidFinishRegister:(FCRegisterTableViewController *)registerTableViewController;

@end

@interface FCRegisterTableViewController : UITableViewController

@property (nonatomic, weak) id<FCRegisterTableViewControllerDelegate> delegate;

@end
