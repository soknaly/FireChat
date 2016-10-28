//
//  FCMessage.m
//  FireChat
//
//  Created by soknaly on 10/21/16.
//  Copyright © 2016 Sokna Ly. All rights reserved.
//

#import "FCMessage.h"

@implementation FCMessage

- (instancetype)initWithUser:(FCUser *)user
                        date:(NSDate *)date
                        text:(NSString *)text {
  self = [super initWithSenderId:user.uid
               senderDisplayName:user.displayName
                            date:date
                            text:text];
  return self;
}

@end
