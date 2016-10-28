//
//  FCAPIService.m
//  FireChat
//
//  Created by soknaly on 10/26/16.
//  Copyright © 2016 Sokna Ly. All rights reserved.
//

#import "FCAPIService.h"

@interface FCAPIService ()

@property (nonatomic, strong) FIRStorageReference *imageStorageReference;

@property (nonatomic, strong) FIRDatabaseReference *userDatabaseReference;

@property (nonatomic, strong) FIRDatabaseReference *chatDatabaseReference;

@property (nonatomic, strong) FIRDatabaseReference *memberDatabaseReference;

@property (nonatomic, strong) FIRDatabaseReference *typingDatabaseReference;

@property (nonatomic, strong) FIRDatabaseReference *messagesDatabaseReference;

@end

@implementation FCAPIService

+ (instancetype)sharedServiced {
  static dispatch_once_t onceToken;
  static FCAPIService *service = nil;
  dispatch_once(&onceToken, ^{
    service = [[self alloc] init];
  });
  return service;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    FIRStorageReference *storageReference = [[FIRStorage storage] referenceForURL:@"gs://firechat-8eacf.appspot.com"];
    self.imageStorageReference = [storageReference child:@"images"];
    FIRDatabaseReference *databaseReference = [[FIRDatabase database] reference];
    self.userDatabaseReference = [databaseReference child:@"users"];
    self.chatDatabaseReference = [databaseReference child:@"chats"];
    self.memberDatabaseReference = [databaseReference child:@"members"];
    self.typingDatabaseReference = [databaseReference child:@"typing"];
    self.messagesDatabaseReference = [databaseReference child:@"messages"];
  }
  return self;
}

- (void)createUserWithID:(NSString *)userID
             displayName:(NSString *)displayName
            emailAddress:(NSString *)emailAddress
                photoURL:(NSURL *)photoURL {
  //TODO: Write Firebase code to save user info
}

- (void)updateCurrentUserWithFirstName:(NSString *)firstName
                              lastName:(NSString *)lastName
                                 email:(NSString *)email
                               success:(void (^)())success
                               failure:(FCErrorResultBlock)failure {
  
  
}


- (void)uploadImage:(UIImage *)image
           withName:(NSString *)imageName
           progress:(void (^)(NSProgress *))progress
            success:(void (^)(NSURL *))success
            failure:(FCErrorResultBlock)failure {
  //TODO: Write Firebase code to upload image to Firebase Storage
}

- (void)searchUserWithEmail:(NSString *)email
                    success:(void (^)(FCUser *))success
                    failure:(FCErrorResultBlock)failure {
  
}

- (void)checkExistingChatWithRecipientID:(NSString *)recipientID
                                 success:(void(^)(BOOL exists))success {
  
}

- (void)addChatWithUser:(FCUser *)user
                success:(void (^)(FCChat *))success
                failure:(FCErrorResultBlock)failure {
  
  
}

- (void)getChatListForCurrentUserWithDelegate:(id<FCAPIServiceDelegate>)delegate {
  
}

- (void)getChatFromSnapshot:(FIRDataSnapshot *)chatSnapshot
                    success:(void(^)(FCChat *chat))succes {
}

- (void)removeChat:(FCChat *)chat {
  
}

- (void)sendMessageWithText:(NSString *)text
                   senderID:(NSString *)senderID
                       date:(NSDate *)date
                    isMedia:(BOOL)isMedia
                    forChat:(FCChat *)chat {
  
  //TODO: Write Firebase code to send message
}

- (void)observeTypingStatusForChat:(FCChat *)chat
                       actionBlock:(void (^)(BOOL))actionBlock {
  
  //TODO: Write firebase code to observe typing status
  
}

- (void)sendOnlineStatus {
  //TODO: Write Firebase code to send online status
}

- (void)sendOfflineStatus {
  //TODO: Write Firebase code to send offline status
}

- (void)sendTypingStatusForChat:(FCChat *)chat {
  //TODO: Write Firebase code to send typing status
}

- (void)sendStopTypingStatusForChat:(FCChat *)chat {
 //TODO: Write Firebase code to send stop typing status
}


@end
