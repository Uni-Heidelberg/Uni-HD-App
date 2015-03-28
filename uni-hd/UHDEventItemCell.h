//
//  UHDEventItemCell.h
//  uni-hd
//
//  Created by Kevin Geier on 07.07.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UHDEventItem.h"

@interface UHDEventItemCell : UITableViewCell

- (void)configureForEvent:(UHDEventItem *)item;

@end
