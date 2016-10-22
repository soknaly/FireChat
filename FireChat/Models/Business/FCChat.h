//
//  FCChat.h
//  FireChat
//
//  Created by soknaly on 10/21/16.
//  Copyright © 2016 Sokna Ly. All rights reserved.
//

#import "FCObject.h"

@interface FCChat : FCObject

@property (nonatomic, strong) NSString *chatId;

@property (nonatomic, strong) NSString *fullName;

@property (nonatomic, strong) NSString *profileImageUrl;

@property (nonatomic, strong) NSString *lastMessage;

@property (nonatomic, getter=isOnline) BOOL online;


- (NSURL* )profileImageURL;

@end
