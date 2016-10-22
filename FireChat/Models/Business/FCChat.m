//
//  FCChat.m
//  FireChat
//
//  Created by soknaly on 10/21/16.
//  Copyright © 2016 Sokna Ly. All rights reserved.
//

#import "FCChat.h"

@implementation FCChat

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
  if (self = [super initWithDictionary:dictionary]) {
    _fullName = dictionary[@"name"];
    _profileImageUrl = dictionary[@"profileImageUrl"];
    _online = [dictionary[@"online"] boolValue];
    _lastMessage = dictionary[@"lastMessage"];
  }
  return self;
}

- (NSURL *)profileImageURL {
  return [NSURL URLWithString:self.profileImageUrl];
}

@end
