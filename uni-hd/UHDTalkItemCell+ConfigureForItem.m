//
//  UHDTalkItemCell+ConfigureForItem.m
//  uni-hd
//
//  Created by Kevin Geier on 07.07.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDTalkItemCell+ConfigureForItem.h"

@implementation UHDTalkItemCell (ConfigureForItem)

- (void)configureForItem:(UHDTalkItem *)item
{
	self.titleLabel.text = item.title;
	self.speakerLabel.text = item.speaker.name;
	self.talkImageView.image = item.thumbImage;
}

@end
