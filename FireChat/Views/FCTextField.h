//
//  FCTextField.h
//  FireChat
//
//  Created by soknaly on 10/21/16.
//  Copyright © 2016 Sokna Ly. All rights reserved.
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE
@interface FCTextField : UITextField

@property (nonatomic, strong) UIImage *leftImage;

@property (nonatomic, assign) IBInspectable BOOL hasBottomLine;

@end
