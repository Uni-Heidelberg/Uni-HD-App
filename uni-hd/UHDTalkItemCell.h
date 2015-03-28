//
//  UHDTalkItemCell.h
//  uni-hd
//
//  Created by Kevin Geier on 07.07.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UHDTalkItem.h"

@interface UHDTalkItemCell : UITableViewCell

- (void)configureForTalk:(UHDTalkItem *)item;

@end
