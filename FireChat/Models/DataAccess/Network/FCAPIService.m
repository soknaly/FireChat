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
  }
  return self;
}

- (void)createUserWithID:(NSString *)userID
             displayName:(NSString *)displayName
            emailAddress:(NSString *)emailAddress
                photoURL:(NSURL *)photoURL {
  FIRDatabaseReference *userReference = [self.userDatabaseReference child:userID];
  NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
  dictionary[@"displayName"] = displayName;
  dictionary[@"email"] = emailAddress;
  dictionary[@"photoURL"] = photoURL.absoluteString;
  [userReference setValue:dictionary];
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

- (void)addChatWithUser:(FCUser *)user
                success:(void (^)(FCChat *))success {
  
  FIRUser *currentUser = [FIRAuth auth].currentUser;
  
  NSTimeInterval nowInterval = [NSDate timeIntervalSinceReferenceDate];
  
  FIRDatabaseReference *currentUserChatDatabaseReference = [[self.chatDatabaseReference child:currentUser.uid] child:user.uid];
  
  FIRDatabaseReference *recipientChatDatabaseReference = [[self.chatDatabaseReference child:user.uid] child:currentUser.uid];
  
  
  NSDictionary *currentUserDictionary = @{@"timestamp":@(nowInterval)};
  
  NSDictionary *recipientUserDictionary = @{@"timestamp":@(nowInterval)};
  
  [currentUserChatDatabaseReference setValue:currentUserDictionary];
  [recipientChatDatabaseReference setValue:recipientUserDictionary];
  
  FIRDatabaseReference *currentUserChatRef = [[self.userDatabaseReference child:currentUser.uid] child:@"chats"];
  
  FIRDatabaseReference *recipientChatRef = [[self.userDatabaseReference child:user.uid] child:@"chats"];
  
  [[currentUserChatRef child:currentUserChatDatabaseReference.key] setValue:@YES];
  [[recipientChatRef child:currentUserChatDatabaseReference.key] setValue:@YES];
  [currentUserChatDatabaseReference setValue:currentUserDictionary];
  
  FCChat *chat = [[FCChat alloc] init];
  FCUser *recipient = [[FCUser alloc] init];
  recipient.displayName = currentUser.displayName;
  recipient.photoURL = currentUser.photoURL;
  chat.recipient = recipient;
  success(chat);
  
}

- (void)getChatListForCurrentUserWithDelegate:(id<FCAPIServiceDelegate>)delegate {
  self.delegate = delegate;
  FIRUser *currentUser = [FIRAuth auth].currentUser;
  FIRDatabaseQuery *currentUserChatDatabaseReference = [[self.chatDatabaseReference child:currentUser.uid] queryOrderedByChild:@"timestamp"];
  [currentUserChatDatabaseReference observeEventType:FIRDataEventTypeChildAdded
                                           withBlock:^(FIRDataSnapshot * _Nonnull chatSnapshot) {
                                             if (chatSnapshot.value != [NSNull null]) {
                                               NSMutableDictionary *chatMutableDictionary = [chatSnapshot.value mutableCopy];
                                               chatMutableDictionary[@"uid"] = chatSnapshot.key;
                                               FIRDatabaseReference *userDatabaseReference = [self.userDatabaseReference child:chatSnapshot.key];
                                               [userDatabaseReference observeSingleEventOfType:FIRDataEventTypeValue
                                                                                     withBlock:^(FIRDataSnapshot * _Nonnull userSnapshot) {
                                                                                       if (userSnapshot.value != [NSNull null]) {
                                                                                         NSMutableDictionary *userMutableDictionary = [userSnapshot.value mutableCopy];
                                                                                         userMutableDictionary[@"uid"] = userSnapshot.key;
                                                                                         chatMutableDictionary[@"recipient"] = userMutableDictionary;
                                                                                         FCChat *chat = [[FCChat alloc] initWithDictionary:chatMutableDictionary];
                                                                                         if ([self.delegate respondsToSelector:@selector(apiService:didAddChat:)]) {
                                                                                           [self.delegate apiService:self didAddChat:chat];
                                                                                         }
                                                                                       }
                                                                                     }];
                                             }
                                             
                                           }];
}

@end
