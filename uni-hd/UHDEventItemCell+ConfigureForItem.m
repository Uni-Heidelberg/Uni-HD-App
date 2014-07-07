//
//  UHDEventItemCell+ConfigureForItem.m
//  uni-hd
//
//  Created by Kevin Geier on 07.07.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDEventItemCell+ConfigureForItem.h"

@implementation UHDEventItemCell (ConfigureForItem)

-(void) configureForItem:(UHDEventItem *)item
{
	self.titleLabel.text = item.title;
	self.locationLabel.text = item.location;
	self.eventImageView.image = item.thumbImage;
}

@end
