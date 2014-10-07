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
	// Configure text
	self.titleLabel.text = item.title;
	self.locationLabel.text = item.location;
	self.abstractLabel.text = item.abstract;
	
	// Configure speaker information
	self.speakerLabel.text = item.speaker.name;
	self.affiliationLabel.text = item.speaker.affiliation;
	
	// Configure date and time
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterFullStyle;
	dateFormatter.timeStyle = NSDateFormatterShortStyle;
    self.dateLabel.text = [dateFormatter stringFromDate:item.date];
	
	// Configure image
	self.talkImageView.image = item.thumbImage;
	
	
	// update layout of multiline labels for changed text lengths
	
	// TODO: use UHDAutoLayoutMultilineLabels class to update preferredMaxLayoutWidth
	
	// TODO: fix bad layout after rotatiting back to vertical
	
	// TODO: use Self sizing cells? (Row Height Estimation, iOS 8)
	
	self.titleLabel.preferredMaxLayoutWidth = self.titleLabel.frame.size.width;
	self.speakerLabel.preferredMaxLayoutWidth = self.speakerLabel.frame.size.width;
	self.affiliationLabel.preferredMaxLayoutWidth = self.affiliationLabel.frame.size.width;
	self.dateLabel.preferredMaxLayoutWidth = self.dateLabel.frame.size.width;
	self.locationLabel.preferredMaxLayoutWidth = self.locationLabel.frame.size.width;
	self.abstractLabel.preferredMaxLayoutWidth = self.abstractLabel.frame.size.width;
	[self setNeedsLayout];
    [self layoutIfNeeded];
}

@end
