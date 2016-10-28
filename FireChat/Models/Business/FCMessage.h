//
//  FCMessage.h
//  FireChat
//
//  Created by soknaly on 10/21/16.
//  Copyright © 2016 Sokna Ly. All rights reserved.
//

#import "JSQMessage.h"

@interface FCMessage : JSQMessage

@property (nonatomic, strong) NSString *uid;

- (instancetype)initWithUser:(FCUser *)user
                        date:(NSDate *)date
                        text:(NSString *)text;

@end
