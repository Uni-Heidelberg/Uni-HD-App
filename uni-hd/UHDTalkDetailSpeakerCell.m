//
//  UHDTalkDetailSpeakerCell.m
//  uni-hd
//
//  Created by Kevin Geier on 13.04.15.
//  Copyright (c) 2015 Universit&#228;t Heidelberg. All rights reserved.
//

#import "UHDTalkDetailSpeakerCell.h"

@interface UHDTalkDetailSpeakerCell ()

@property (weak, nonatomic) IBOutlet UIButton *speakerLabel;
@property (weak, nonatomic) IBOutlet UILabel *affiliationLabel;


@end


@implementation UHDTalkDetailSpeakerCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureForItem:(UHDTalkItem *)item {
	
    [self.speakerLabel setTitle:item.speaker.name forState:UIControlStateNormal];
	/*
	UIFontDescriptor *fontDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleBody];
	UIFontDescriptor *boldDescriptor = [fontDescriptor fontDescriptorWithSymbolicTraits:(fontDescriptor.symbolicTraits | UIFontDescriptorTraitBold)];
	self.speakerLabel.font = [UIFont fontWithDescriptor:boldDescriptor size:boldDescriptor.pointSize];
	*/
	self.affiliationLabel.text = item.speaker.affiliation;
	
	[self setNeedsLayout];
	[self layoutIfNeeded];
}

@end
