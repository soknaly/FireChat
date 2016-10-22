//
//  FCGroup.m
//  FireChat
//
//  Created by soknaly on 10/22/16.
//  Copyright © 2016 Sokna Ly. All rights reserved.
//

#import "FCGroup.h"

@implementation FCGroup


- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
  if (self = [super initWithDictionary:dictionary]) {
    _name = dictionary[@"name"];
    _lastMessage = dictionary[@"lastMessage"];
    _lastMessageSenderName = dictionary[@"lastMessageSenderName"];
  }
  return self;
}

@end
