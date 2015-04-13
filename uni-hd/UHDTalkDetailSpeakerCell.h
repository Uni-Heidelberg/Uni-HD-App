//
//  UHDTalkDetailSpeakerCell.h
//  uni-hd
//
//  Created by Kevin Geier on 13.04.15.
//  Copyright (c) 2015 Universit&#228;t Heidelberg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UHDTalkItem.h"
#import "UHDTalkSpeaker.h"

@interface UHDTalkDetailSpeakerCell : UITableViewCell

- (void)configureForItem:(UHDTalkItem *)item;

@end
