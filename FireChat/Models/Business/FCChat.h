//
//  FCChat.h
//  FireChat
//
//  Created by soknaly on 10/21/16.
//  Copyright © 2016 Sokna Ly. All rights reserved.
//

#import "FCObject.h"
#import "FCUser.h"

@interface FCChat : FCObject

@property (nonatomic, strong) NSString *uid;

@property (nonatomic, strong) NSString *lastMessage;

@property (nonatomic, strong) NSString *lastSenderID;

@property (nonatomic, strong) FCUser *recipient;

@end
