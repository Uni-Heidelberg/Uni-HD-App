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
	// Configure text
	self.titleLabel.text = item.title;
	self.locationLabel.text = item.location;
	self.abstractLabel.text = item.abstract;
	
	// Configure date and time
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterFullStyle;
	dateFormatter.timeStyle = NSDateFormatterShortStyle;
    self.dateLabel.text = [dateFormatter stringFromDate:item.date];
	
	// Configure image
	self.eventImageView.image = item.thumbImage;
	
	// TODO: bad layout after rotatiting back to vertical
	
	// update layout of multiline labels for changed text lengths
	self.titleLabel.preferredMaxLayoutWidth = self.titleLabel.frame.size.width;
	self.dateLabel.preferredMaxLayoutWidth = self.dateLabel.bounds.size.width;
	self.locationLabel.preferredMaxLayoutWidth = self.locationLabel.frame.size.width;
	self.abstractLabel.preferredMaxLayoutWidth = self.abstractLabel.frame.size.width;
    [self layoutIfNeeded];
}

@end
