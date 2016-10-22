//
//  FCSettingHeaderView.h
//  FireChat
//
//  Created by soknaly on 10/22/16.
//  Copyright © 2016 Sokna Ly. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FCSettingHeaderView;

@protocol FCSettingHeaderViewDelegate <NSObject>

- (void)settingHeaderViewDidClickProfile:(FCSettingHeaderView *)headerView;


@end

@interface FCSettingHeaderView : UIView

@property (nonatomic, weak, readonly) UIImageView *profileImageView;

@property (nonatomic, weak, readonly) UILabel *nameLabel;

@property (nonatomic, weak) id<FCSettingHeaderViewDelegate> delegate;

@end
