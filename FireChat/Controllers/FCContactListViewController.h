//
//  FCContactListViewController.h
//  FireChat
//
//  Created by soknaly on 10/22/16.
//  Copyright © 2016 Sokna Ly. All rights reserved.
//

#import "FCBaseViewController.h"
#import "FCChat.h"

@class FCContactListViewController;


@protocol FCContactListViewControllerDelegate <NSObject>

- (void)contactListViewController:(FCContactListViewController *)contactListViewController
                didSelectContacts:(NSArray<FCChat *>* )contacts;

@end

@interface FCContactListViewController : FCBaseViewController

@property (nonatomic, weak) id<FCContactListViewControllerDelegate> delegate;

@end
