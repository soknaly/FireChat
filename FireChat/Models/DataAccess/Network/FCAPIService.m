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
  
  FIRUser *currentUser = [FIRAuth auth].currentUser;
  FIRUserProfileChangeRequest *changeRequest = [currentUser profileChangeRequest];
  changeRequest.displayName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
  [changeRequest commitChangesWithCompletion:^(NSError * _Nullable error) {
    if (!error) {
      [currentUser updateEmail:email
                    completion:^(NSError * _Nullable error) {
                      if (!error) {
                        [self createUserWithID:currentUser.uid
                                   displayName:changeRequest.displayName
                                  emailAddress:email
                                      photoURL:nil];
                        success();
                      } else {
                        failure(error);
                      }
                    }];
    } else {
      failure(error);
    }
  }];
}


- (void)uploadImage:(UIImage *)image
           withName:(NSString *)imageName
           progress:(void (^)(NSProgress *))progress
            success:(void (^)(NSURL *))success
            failure:(FCErrorResultBlock)failure {
  if (!image) {
    success(nil);
    return;
  }
  FIRStorageReference *photoStorageReference = [self.imageStorageReference child:imageName];
  
  FIRStorageMetadata *metadata = [[FIRStorageMetadata alloc] init];
  metadata.contentType = @"image/jpeg";
  
  FIRStorageUploadTask *uploadTask = [photoStorageReference putData:UIImageJPEGRepresentation(image, 1)
                                                           metadata:metadata
                                                         completion:^(FIRStorageMetadata * _Nullable metadata, NSError * _Nullable error) {
                                                           if (error) {
                                                             failure(error);
                                                           } else {
                                                             success(metadata.downloadURL);
                                                           }
                                                         }];
  if (progress) {
    [uploadTask observeStatus:FIRStorageTaskStatusProgress
                      handler:^(FIRStorageTaskSnapshot * _Nonnull snapshot) {
                        progress(snapshot.progress);
                      }];
  }
  
}

- (void)searchUserWithEmail:(NSString *)email
                    success:(void (^)(FCUser *))success
                    failure:(FCErrorResultBlock)failure {
  FIRUser *currentUser = [FIRAuth auth].currentUser;
  if ([email isEqualToString:currentUser.email]) {
    success(nil);
    return;
  }
  FIRDatabaseQuery *emailQuery = [[self.userDatabaseReference queryOrderedByChild:@"email"] queryEqualToValue:email];
  [emailQuery observeSingleEventOfType:FIRDataEventTypeValue
                             withBlock:^(FIRDataSnapshot * _Nonnull userSnapshot) {
                               if (userSnapshot.exists) {
                                 NSString *uid = [userSnapshot.value allKeys].firstObject;
                                 NSMutableDictionary *userMutableDictionary = userSnapshot.value[uid];
                                 userMutableDictionary[@"uid"] = uid;
                                 FCUser *user = [[FCUser alloc] initWithDictionary:userMutableDictionary];
                                 success(user);
                               } else {
                                 success(nil);
                               }
                             }
                       withCancelBlock:^(NSError * _Nonnull error) {
                         failure(error);
                       }];
}

- (void)checkExistingChatWithRecipientID:(NSString *)recipientID
                                 success:(void(^)(BOOL exists))success {
  FIRUser *currentUser = [FIRAuth auth].currentUser;
  FIRDatabaseQuery *chatQuery = [[[self.chatDatabaseReference child:currentUser.uid] queryOrderedByChild:@"recipientID"] queryEqualToValue:recipientID];
  [chatQuery observeSingleEventOfType:FIRDataEventTypeValue
                            withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                              success(snapshot.exists);
                            }];
}

- (void)addChatWithUser:(FCUser *)user
                success:(void (^)(FCChat *))success
                failure:(FCErrorResultBlock)failure {
  
  [self checkExistingChatWithRecipientID:user.uid success:^(BOOL exists) {
    if (!exists) {
      FIRUser *currentUser = [FIRAuth auth].currentUser;
      
      NSTimeInterval nowInterval = [NSDate timeIntervalSinceReferenceDate];
      
      FIRDatabaseReference *currentUserChatDatabaseReference = [[self.chatDatabaseReference child:currentUser.uid] childByAutoId];
      
      FIRDatabaseReference *recipientChatDatabaseReference = [[self.chatDatabaseReference child:user.uid] child:currentUserChatDatabaseReference.key];
      
      
      NSDictionary *currentUserDictionary = @{@"timestamp":@(-nowInterval),
                                              @"recipientID":user.uid};
      
      NSDictionary *recipientUserDictionary = @{@"timestamp":@(-nowInterval),
                                                @"recipientID":currentUser.uid};
      
      [currentUserChatDatabaseReference setValue:currentUserDictionary];
      [recipientChatDatabaseReference setValue:recipientUserDictionary];
      
      FIRDatabaseReference *currentUserChatRef = [[self.userDatabaseReference child:currentUser.uid] child:@"chats"];
      [[currentUserChatRef child:currentUserChatDatabaseReference.key] setValue:@YES];
      
      FIRDatabaseReference *recipientChatRef = [[self.userDatabaseReference child:user.uid] child:@"chats"];
      [[recipientChatRef child:currentUserChatDatabaseReference.key] setValue:@YES];
      
      [currentUserChatDatabaseReference setValue:currentUserDictionary];
      
      FCChat *chat = [[FCChat alloc] init];
      FCUser *recipient = [[FCUser alloc] init];
      recipient.displayName = currentUser.displayName;
      recipient.photoURL = currentUser.photoURL;
      recipient.uid = currentUser.uid;
      chat.recipient = recipient;
      chat.uid = currentUserChatDatabaseReference.key;
      success(chat);
    } else {
      NSError *error = [NSError errorWithDomain:@"kFCErrorDomain"
                                           code:409
                                       userInfo:@{NSLocalizedDescriptionKey:@"You already has a chat with this user"}];
      failure(error);
    }
  }];
  
}

- (void)getChatListForCurrentUserWithDelegate:(id<FCAPIServiceDelegate>)delegate {
  self.delegate = delegate;
  FIRUser *currentUser = [FIRAuth auth].currentUser;
  
  FIRDatabaseQuery *currentUserChatDatabaseReference = [[self.chatDatabaseReference child:currentUser.uid] queryOrderedByChild:@"timestamp"];
  [currentUserChatDatabaseReference observeEventType:FIRDataEventTypeChildAdded
                                           withBlock:^(FIRDataSnapshot * _Nonnull chatSnapshot) {
                                             [self getChatFromSnapshot:chatSnapshot success:^(FCChat *chat) {
                                               if ([self.delegate respondsToSelector:@selector(apiService:didAddChat:)]) {
                                                 [self.delegate apiService:self didAddChat:chat];
                                               }
                                             }];
                                           }];
  
  [currentUserChatDatabaseReference observeEventType:FIRDataEventTypeChildChanged
                                           withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                                             [self getChatFromSnapshot:snapshot success:^(FCChat *chat) {
                                               if ([self.delegate respondsToSelector:@selector(apiService:didUpdateChat:)]) {
                                                 [self.delegate apiService:self didUpdateChat:chat];
                                               }
                                             }];
                                           }];
  
  [currentUserChatDatabaseReference observeEventType:FIRDataEventTypeChildMoved
                                           withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                                             [self getChatFromSnapshot:snapshot success:^(FCChat *chat) {
                                               if ([self.delegate respondsToSelector:@selector(apiService:didMoveChat:)]) {
                                                 [self.delegate apiService:self didMoveChat:chat];
                                               }
                                             }];
                                           }];
  
  [currentUserChatDatabaseReference observeEventType:FIRDataEventTypeChildRemoved
                                           withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                                             [self getChatFromSnapshot:snapshot success:^(FCChat *chat) {
                                               if ([self.delegate respondsToSelector:@selector(apiService:didRemoveChat:)]) {
                                                 [self.delegate apiService:self didRemoveChat:chat];
                                               }
                                             }];
                                           }];
  
}

- (void)getChatFromSnapshot:(FIRDataSnapshot *)chatSnapshot
                    success:(void(^)(FCChat *chat))succes {
  
  if (chatSnapshot.value != [NSNull null]) {
    NSMutableDictionary *chatMutableDictionary = [chatSnapshot.value mutableCopy];
    chatMutableDictionary[@"uid"] = chatSnapshot.key;
    FIRDatabaseReference *userDatabaseReference = [self.userDatabaseReference child:chatSnapshot.value[@"recipientID"]];
    [userDatabaseReference observeSingleEventOfType:FIRDataEventTypeValue
                                          withBlock:^(FIRDataSnapshot * _Nonnull userSnapshot) {
                                            if (userSnapshot.value != [NSNull null]) {
                                              NSMutableDictionary *userMutableDictionary = [userSnapshot.value mutableCopy];
                                              userMutableDictionary[@"uid"] = userSnapshot.key;
                                              chatMutableDictionary[@"recipient"] = userMutableDictionary;
                                              FCChat *chat = [[FCChat alloc] initWithDictionary:chatMutableDictionary];
                                              succes(chat);
                                            }
                                          }];
  }
}

- (void)removeChat:(FCChat *)chat {
  FIRUser *currentUser = [FIRAuth auth].currentUser;
  FIRDatabaseReference *chatRef = [self.chatDatabaseReference child:currentUser.uid];
  FIRDatabaseReference *recipientChatRef = [self.chatDatabaseReference child:chat.recipient.uid];
  [[chatRef child:chat.uid] removeValue];
  [[recipientChatRef child:chat.uid] removeValue];
}

- (void)sendMessageWithText:(NSString *)text
                   senderID:(NSString *)senderID
                       date:(NSDate *)date
                    isMedia:(BOOL)isMedia
                    forChat:(FCChat *)chat {
  
  FIRUser *currentUser = [FIRAuth auth].currentUser;
  
  NSString *lastMessage = text;
  if (isMedia) {
    lastMessage = @"Sent a photo";
  }
  FIRDatabaseReference *messagesDatabaseReference = [[self.messagesDatabaseReference child:chat.uid] childByAutoId];
  
  //Update Current User Chat
  FIRDatabaseReference *currentUserChatDatabaseReference = [[self.chatDatabaseReference child:currentUser.uid] child:chat.uid];
  [[currentUserChatDatabaseReference child:@"lastMessage"] setValue:lastMessage];
  [[currentUserChatDatabaseReference child:@"timestamp"] setValue:@(-[date timeIntervalSinceReferenceDate])];
  [[currentUserChatDatabaseReference child:@"lastSenderID"] setValue:currentUser.uid];
  
  //Update Recipient Chat
  
  FIRDatabaseReference *recipientChatDatabaseReference = [[self.chatDatabaseReference child:chat.recipient.uid] child:chat.uid];
  [[recipientChatDatabaseReference child:@"lastMessage"] setValue:lastMessage];
  [[recipientChatDatabaseReference child:@"timestamp"] setValue:@(-[date timeIntervalSinceReferenceDate])];
  [[recipientChatDatabaseReference child:@"lastSenderID"] setValue:currentUser.uid];
  
  
  //Set Message Data
  NSMutableDictionary *messageDictionary = [NSMutableDictionary dictionary];
  messageDictionary[@"message"] = text;
  messageDictionary[@"senderID"] = senderID;
  messageDictionary[@"timestamp"] = @([date timeIntervalSinceReferenceDate]);
  if (isMedia) {
    messageDictionary[@"isMedia"] = @(isMedia);
  }
  
  [messagesDatabaseReference setValue:messageDictionary];
}

- (void)observeTypingStatusForChat:(FCChat *)chat
                       actionBlock:(void (^)(BOOL))actionBlock {
  
  FIRDatabaseReference *typingRef = [[self.typingDatabaseReference child:chat.uid] child:chat.recipient.uid];
  [typingRef observeEventType:FIRDataEventTypeValue
                    withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                      actionBlock(snapshot.value != [NSNull null] &&
                                  [snapshot.value boolValue]);
                    }];
  
}

- (void)sendOnlineStatus {
  FIRUser *currentUser = [FIRAuth auth].currentUser;
  if (!currentUser) return;
  FIRDatabaseReference *currentUserDatabaseRef = [self.userDatabaseReference child:currentUser.uid];
  [[currentUserDatabaseRef child:@"online"] setValue:@YES];
  [[currentUserDatabaseRef child:@"online"] onDisconnectSetValue:@NO];
}

- (void)sendOfflineStatus {
  FIRUser *currentUser = [FIRAuth auth].currentUser;
  if (!currentUser) return;
  FIRDatabaseReference *currentUserDatabaseRef = [self.userDatabaseReference child:currentUser.uid];
  [[currentUserDatabaseRef child:@"online"] setValue:@NO];
}

- (void)sendTypingStatusForChat:(FCChat *)chat {
  FIRUser *currentUser = [FIRAuth auth].currentUser;
  if (!currentUser) return;
  FIRDatabaseReference *currentUserTypingRef = [[self.typingDatabaseReference child:chat.uid] child:currentUser.uid];
  [currentUserTypingRef setValue:@YES];
  [currentUserTypingRef onDisconnectRemoveValue];
}

- (void)sendStopTypingStatusForChat:(FCChat *)chat {
  FIRUser *currentUser = [FIRAuth auth].currentUser;
  if (!currentUser) return;
  FIRDatabaseReference *currentUserTypingRef = [[self.typingDatabaseReference child:chat.uid] child:currentUser.uid];
  [currentUserTypingRef setValue:@NO];
}


@end
