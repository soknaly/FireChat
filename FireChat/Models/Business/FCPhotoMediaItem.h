//
//  FCPhotoMediaItem.h
//  FireChat
//
//  Created by soknaly on 10/28/16.
//  Copyright © 2016 Sokna Ly. All rights reserved.
//

#import "JSQPhotoMediaItem.h"

@interface FCPhotoMediaItem : JSQPhotoMediaItem

@property (nonatomic, strong) UIImageView *asyncImageView;

- (instancetype)initWithURL:(NSURL *)URL;

@end
