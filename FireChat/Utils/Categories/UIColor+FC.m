//
//  UIColor+FC.m
//  FireChat
//
//  Created by soknaly on 10/21/16.
//  Copyright © 2016 Sokna Ly. All rights reserved.
//

#import "UIColor+FC.h"

@implementation UIColor (FC)

+ (instancetype)mainColor {
  return [UIColor colorWithRed:42/255.0 green:152/255.0 blue:255/255.0 alpha:1];
}

+ (instancetype)onlineIndicatorColor {
  return [UIColor colorWithRed:54/255 green:181/255 blue:129/255 alpha:1];
}

+ (instancetype)offlineIndicatorColor {
  return [UIColor colorWithRed:220/255 green:220/255 blue:220/255 alpha:1];
}

+ (instancetype)messageBubbleLightGrayColor {
  return [UIColor colorWithHue:240.0f / 360.0f
                    saturation:0.02f
                    brightness:0.92f
                         alpha:1.0f];
}

@end
