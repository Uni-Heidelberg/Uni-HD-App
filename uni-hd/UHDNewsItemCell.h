//
//  UHDNewsItemCell.h
//  uni-hd
//
//  Created by Kevin Geier on 14.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UHDNewsItem.h"


@interface UHDNewsItemCell : UITableViewCell

- (void)configureForItem:(UHDNewsItem *)item;

@end
