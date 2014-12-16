//
//  UHDTalkDetailPlaceTimeCell.h
//  uni-hd
//
//  Created by Kevin Geier on 12.12.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UHDTalkItem.h"

@interface UHDTalkDetailSpaceTimeCell : UITableViewCell // super cool name :>

- (void)configureForItem:(UHDTalkItem *)item;

@end
