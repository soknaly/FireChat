//
//  FCBaseTableViewCell.m
//  FireChat
//
//  Created by soknaly on 10/21/16.
//  Copyright © 2016 Sokna Ly. All rights reserved.
//

#import "FCBaseTableViewCell.h"

@implementation FCBaseTableViewCell

+ (void)registerNibForTableView:(UITableView *)tableView {
  [tableView registerNib:[UINib nibWithNibName:[self identifier] bundle:[NSBundle mainBundle]]
  forCellReuseIdentifier:[self identifier]];
}

+ (NSString *)identifier {
  return NSStringFromClass([self class]);
}

@end
