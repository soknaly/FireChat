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
            failure:(void (^)(NSError *))failure {
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
                    failure:(void (^)(NSError *))failure {
  
  FIRDatabaseQuery *emailQuery = [[self.userDatabaseReference queryOrderedByChild:@"email"] queryEqualToValue:email];
  [emailQuery observeSingleEventOfType:FIRDataEventTypeValue
                             withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                               if (snapshot.exists) {
                                 FCUser *user = [[FCUser alloc] initWithDictionary:snapshot.value];
                                 success(user);
                               } else {
                                 success(nil);
                               }
                             }
                       withCancelBlock:^(NSError * _Nonnull error) {
                         failure(error);
                       }];
}

@end
