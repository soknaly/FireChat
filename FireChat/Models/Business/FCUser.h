//
//  FCUser.h
//  FireChat
//
//  Created by soknaly on 10/26/16.
//  Copyright © 2016 Sokna Ly. All rights reserved.
//

#import "FCObject.h"

@interface FCUser : FCObject

@property (nonatomic, strong) NSString *displayName;

@property (nonatomic, strong) NSURL *photoURL;

@property (nonatomic, strong) NSString *emailAddress;

@property (nonatomic, strong) NSString *uid;

@property (nonatomic) BOOL online;

@end
