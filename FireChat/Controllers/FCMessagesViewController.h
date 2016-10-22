//
//  FCMessagesViewController.h
//  FireChat
//
//  Created by soknaly on 10/21/16.
//  Copyright © 2016 Sokna Ly. All rights reserved.
//

#import <JSQMessagesViewController/JSQMessagesViewController.h>
#import "FCChat.h"

@interface FCMessagesViewController : JSQMessagesViewController

@property (nonatomic, strong) FCChat *chat;

@end
