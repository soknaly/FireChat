//
//  FCAddChatViewController.h
//  FireChat
//
//  Created by soknaly on 10/22/16.
//  Copyright © 2016 Sokna Ly. All rights reserved.
//

#import "FCBaseViewController.h"

@class FCAddChatViewController;

@protocol FCAddChatViewControllerDelegate <NSObject>

- (void)addChatViewController:(FCAddChatViewController *)chatViewController
                   didAddChat:(FCChat *)chat;

@end

@interface FCAddChatViewController : FCBaseViewController

@property (nonatomic, weak) id<FCAddChatViewControllerDelegate> delegate;

@end
