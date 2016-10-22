//
//  FCBaseTableViewCell.h
//  FireChat
//
//  Created by soknaly on 10/21/16.
//  Copyright © 2016 Sokna Ly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FCBaseTableViewCell : UITableViewCell

+ (void)registerNibForTableView:(UITableView *)tableView;

+ (NSString *)identifier;

@end
