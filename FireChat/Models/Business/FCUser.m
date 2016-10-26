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
    NSString *userID = [dictionary allKeys].firstObject;
    NSDictionary *userDictionary = dictionary[userID];
    _displayName = userDictionary[@"displayName"];
    _emailAddress = userDictionary[@"email"];
    NSString *photoURLString = userDictionary[@"photoURL"];
    if (photoURLString) {
     _photoURL = [NSURL URLWithString:photoURLString];
    }
    _uid = userID;
    
  }
  return self;
}


@end
