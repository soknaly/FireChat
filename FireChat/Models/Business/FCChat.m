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
    _lastMessage = dictionary[@"lastMessage"];
    FCUser *recipient = [[FCUser alloc] initWithDictionary:dictionary[@"recipient"]];
    _recipient = recipient;
  }
  return self;
}

@end
