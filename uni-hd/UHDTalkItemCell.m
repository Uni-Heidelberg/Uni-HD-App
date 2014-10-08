//
//  UHDTalkItemCell.m
//  uni-hd
//
//  Created by Kevin Geier on 07.07.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDTalkItemCell.h"
#import "UHDNewsSource.h"

// Model
#import "UHDTalkSpeaker.h"

@interface UHDTalkItemCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *speakerLabel;
@property (weak, nonatomic) IBOutlet UILabel *affiliationLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *abstractLabel;
@property (weak, nonatomic) IBOutlet UIImageView *talkImageView;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;

@end


@implementation UHDTalkItemCell

- (void)awakeFromNib {
	[super awakeFromNib];
	
	// fixes multiline label autolayout issue that layout is only updated when cell is dequeued
	[self updateConstraints];
	[self updateConstraintsIfNeeded];
	[self setNeedsLayout];
	[self layoutIfNeeded];
}

- (void)configureForItem:(UHDTalkItem *)item
{
    // Configure text
    self.titleLabel.text = item.title;
    self.locationLabel.text = item.location;
    self.abstractLabel.text = item.abstract;
	self.sourceLabel.text = item.source.title;
    
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
