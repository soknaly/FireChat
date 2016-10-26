//
//  FCAPIService.h
//  FireChat
//
//  Created by soknaly on 10/26/16.
//  Copyright © 2016 Sokna Ly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FCUser.h"

@interface FCAPIService : NSObject

+ (instancetype)sharedServiced;

- (void)uploadImage:(UIImage *)image
           withName:(NSString *)imageName
           progress:(void(^)(NSProgress *progress))progress
            success:(void(^)(NSURL *imageURL))success
            failure:(void(^)(NSError *error))failure;

- (void)createUserWithID:(NSString *)userID
             displayName:(NSString *)displayName
            emailAddress:(NSString *)emailAddress
                photoURL:(NSURL *)photoURL;

- (void)searchUserWithEmail:(NSString *)email
                    success:(void(^)(FCUser *user))success
                    failure:(void(^)(NSError *error))failure;

@end
