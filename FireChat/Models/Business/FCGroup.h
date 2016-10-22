//
//  FCGroup.h
//  FireChat
//
//  Created by soknaly on 10/22/16.
//  Copyright © 2016 Sokna Ly. All rights reserved.
//

#import "FCObject.h"

@interface FCGroup : FCObject

@property (nonatomic, strong) NSString *groupId;

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *lastMessageSenderName;

@property (nonatomic, strong) NSString *lastMessage;

@end
