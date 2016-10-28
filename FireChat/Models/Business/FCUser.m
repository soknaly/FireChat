//
//  FCUser.m
//  FireChat
//
//  Created by soknaly on 10/26/16.
//  Copyright © 2016 Sokna Ly. All rights reserved.
//

#import "FCUser.h"

@implementation FCUser


- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
  self = [super initWithDictionary:dictionary];
  if (self) {
    _displayName = dictionary[@"displayName"];
    _emailAddress = dictionary[@"email"];
    NSString *photoURLString = dictionary[@"photoURL"];
    if (photoURLString) {
     _photoURL = [NSURL URLWithString:photoURLString];
    }
    _uid = dictionary[@"uid"];
    _online = [dictionary[@"online"] boolValue];
    
  }
  return self;
}


@end
