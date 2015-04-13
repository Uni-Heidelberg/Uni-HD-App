//
//  UHDTalkDetailTimeCell.m
//  uni-hd
//
//  Created by Kevin Geier on 13.04.15.
//  Copyright (c) 2015 Universit&#228;t Heidelberg. All rights reserved.
//

#import "UHDTalkDetailTimeCell.h"
#import "UIColor+UHDColors.h"

@interface UHDTalkDetailTimeCell ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addToCalendarLabel;

@end


@implementation UHDTalkDetailTimeCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureForItem:(UHDTalkItem *)item {
	
	// Configure date and time
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
	[dateFormatter setDateStyle:NSDateFormatterFullStyle];
	self.timeLabel.text = [dateFormatter stringFromDate:item.date];
	/*
	UIFontDescriptor *fontDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleBody];
	UIFontDescriptor *boldDescriptor = [fontDescriptor fontDescriptorWithSymbolicTraits:(fontDescriptor.symbolicTraits | UIFontDescriptorTraitBold)];
	self.timeLabel.font = [UIFont fontWithDescriptor:boldDescriptor size:boldDescriptor.pointSize];
	*/
	self.timeLabel.textColor = [UIColor brandColor];
	
	self.addToCalendarLabel.text = nil; //NSLocalizedString(@"Veranstaltung in den Kalender eintragen", nil);
	self.addToCalendarLabel.textColor = [UIColor brandColor];
}

@end
