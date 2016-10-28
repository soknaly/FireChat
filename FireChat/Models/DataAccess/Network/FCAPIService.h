//
//  FCAPIService.h
//  FireChat
//
//  Created by soknaly on 10/26/16.
//  Copyright © 2016 Sokna Ly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FCUser.h"
#import "FCChat.h"

@class FCAPIService;

@protocol FCAPIServiceDelegate <NSObject>

- (void)apiService:(FCAPIService *)apiService
        didAddChat:(FCChat *)chat;

- (void)apiService:(FCAPIService *)apiService
        didRemoveChat:(FCChat *)chat;

- (void)apiService:(FCAPIService *)apiService
        didMoveChat:(FCChat *)chat;

@end

typedef NS_ENUM(NSInteger,FCChatType) {
  FCChatTypePrivate = 0,
  FCChatTypeGroup
};

typedef void (^FCErrorResultBlock)(NSError *error);

@interface FCAPIService : NSObject

@property (nonatomic, weak) id<FCAPIServiceDelegate> delegate;

+ (instancetype)sharedServiced;

- (void)uploadImage:(UIImage *)image
           withName:(NSString *)imageName
           progress:(void(^)(NSProgress *progress))progress
            success:(void(^)(NSURL *imageURL))success
            failure:(FCErrorResultBlock)failure;

- (void)createUserWithID:(NSString *)userID
             displayName:(NSString *)displayName
            emailAddress:(NSString *)emailAddress
                photoURL:(NSURL *)photoURL;

- (void)searchUserWithEmail:(NSString *)email
                    success:(void(^)(FCUser *user))success
                    failure:(FCErrorResultBlock)failure;

- (void)addChatWithUser:(FCUser *)user
                success:(void(^)(FCChat *))success;

- (void)getChatListForCurrentUserWithDelegate:(id<FCAPIServiceDelegate>)delegate;

@end
