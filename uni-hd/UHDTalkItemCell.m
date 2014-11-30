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
@property (weak, nonatomic) IBOutlet UIImageView *talkIndicatorView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageSpacingLayoutConstraint;
@property (nonatomic) CGFloat imageSpacingConstraintInitialConstant;

@end


@implementation UHDTalkItemCell

- (void)awakeFromNib {
	[super awakeFromNib];
	self.imageSpacingConstraintInitialConstant = self.imageSpacingLayoutConstraint.constant;
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
	if (item.thumbImage) {
		self.imageSpacingLayoutConstraint.constant = self.imageSpacingConstraintInitialConstant;
	}
	else {
		self.imageSpacingLayoutConstraint.constant = 0;
	}
    
    // Layout multiline labels for updated content
    [self layoutIfNeeded];
}


@end
