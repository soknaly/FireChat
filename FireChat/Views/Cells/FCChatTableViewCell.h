//
//  FCChatTableViewCell.h
//  FireChat
//
//  Created by soknaly on 10/21/16.
//  Copyright © 2016 Sokna Ly. All rights reserved.
//

#import "FCBaseTableViewCell.h"
#import "FCChat.h"

@interface FCChatTableViewCell : FCBaseTableViewCell

- (void)populateWithChat:(FCChat *)chat;

@end
