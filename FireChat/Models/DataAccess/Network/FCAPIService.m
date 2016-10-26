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
  }
  return self;
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

@end
