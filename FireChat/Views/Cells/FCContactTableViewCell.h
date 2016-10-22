//
//  FCContactTableViewCell.h
//  FireChat
//
//  Created by soknaly on 10/22/16.
//  Copyright © 2016 Sokna Ly. All rights reserved.
//

#import "FCBaseTableViewCell.h"
#import "FCChat.h"

@interface FCContactTableViewCell : FCBaseTableViewCell

- (void)populateWithContact:(FCChat *)contact;

@end
