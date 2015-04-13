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
@property (weak, nonatomic) IBOutlet UILabel *abstractLabel;
@property (weak, nonatomic) IBOutlet UIImageView *talkImageView;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sourceIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *shortDateAndTimeLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageSpacingLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleSpeakerSpacingLayoutConstraint;

@property (nonatomic) CGFloat imageSpacingConstraintInitialConstant;
@property (nonatomic) CGFloat titleSpeakerSpacingConstraintInitialConstant;

@end


@implementation UHDTalkItemCell

- (void)awakeFromNib {
	[super awakeFromNib];
	self.imageSpacingConstraintInitialConstant = self.imageSpacingLayoutConstraint.constant;
	self.titleSpeakerSpacingConstraintInitialConstant = self.titleSpeakerSpacingLayoutConstraint.constant;
}

- (void)configureForTalk:(UHDTalkItem *)item
{
    // Configure text
    self.titleLabel.text = item.title;
    //self.locationLabel.text = item.location;
    self.abstractLabel.text = item.abstract;
	self.sourceLabel.text = item.source.title;
    
    // Configure speaker information
    self.speakerLabel.text = item.speaker.name;
    self.affiliationLabel.text = item.speaker.affiliation;
	
	if ((self.speakerLabel.text.length == 0) && (self.affiliationLabel.text.length == 0)) {
		self.titleSpeakerSpacingLayoutConstraint.constant = 0;
	}
	else {
		self.titleSpeakerSpacingLayoutConstraint.constant = self.titleSpeakerSpacingConstraintInitialConstant;
	}
    
	// Configure date and time
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
	[calendar setTimeZone:timeZone];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setCalendar:calendar];
	/*
	NSString *formatTemplate = [NSDateFormatter dateFormatFromTemplate:@"MMMM YYYY" options:0 locale:[NSLocale currentLocale]];
	[dateFormatter setDateFormat:formatTemplate];
	*/
	[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	self.shortDateAndTimeLabel.text = [dateFormatter stringFromDate:item.date];
	/*
	// Show time in a new line
	[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	NSString *dateString = [dateFormatter stringFromDate:item.date];
	[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
	[dateFormatter setDateStyle:NSDateFormatterNoStyle];
	NSString *timeString = [dateFormatter stringFromDate:item.date];
	self.shortDateAndTimeLabel.text = [NSString stringWithFormat:@"%@\n%@", dateString, timeString];
	*/
    
    // Configure image
	self.sourceIconImageView.image = item.source.image;
    self.talkImageView.image = item.image;
	if (self.talkImageView.image) {
		self.imageSpacingLayoutConstraint.constant = self.imageSpacingConstraintInitialConstant;
	} else {
		self.imageSpacingLayoutConstraint.constant = 0;
	}
    
    [self setNeedsUpdateConstraints];
	[self updateConstraintsIfNeeded];
	
	// layout multiline labels for updated content
	[self setNeedsLayout];
	[self layoutIfNeeded];
}


@end
