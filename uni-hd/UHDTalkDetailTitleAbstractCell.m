//
//  UHDTalkDetailTitleCell.m
//  uni-hd
//
//  Created by Kevin Geier on 12.12.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDTalkDetailTitleAbstractCell.h"

@interface UHDTalkDetailTitleAbstractCell ()

@property (weak, nonatomic) IBOutlet UITextView *titleTextView;
@property (weak, nonatomic) IBOutlet UIButton *speakerButton;
@property (weak, nonatomic) IBOutlet UILabel *affiliationLabel;
@property (weak, nonatomic) IBOutlet UITextView *abstractTextView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *affiliationAbstractSpacingLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *speakerAffiliationSpacingLayoutConstraint;
@property (nonatomic) CGFloat affiliationAbstractSpacingConstraintInitialConstant;
@property (nonatomic) CGFloat speakerAffiliationSpacingLayoutConstraintInitialConstant;

@end


@implementation UHDTalkDetailTitleAbstractCell

- (void)awakeFromNib {
	
	self.affiliationAbstractSpacingConstraintInitialConstant = self.affiliationAbstractSpacingLayoutConstraint.constant;
	self.speakerAffiliationSpacingLayoutConstraintInitialConstant = self.speakerAffiliationSpacingLayoutConstraint.constant;
}

- (void)configureForItem:(UHDTalkItem *)item {

	self.titleTextView.text = item.title;
	self.titleTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	
	[self.speakerButton setTitle:item.speaker.name forState:UIControlStateNormal];
	self.affiliationLabel.text = item.speaker.affiliation;
	
	if ((item.speaker.name.length == 0) && (item.speaker.affiliation.length == 0)) {
		self.affiliationAbstractSpacingLayoutConstraint.constant = 0;
		self.speakerAffiliationSpacingLayoutConstraint.constant = self.speakerButton.frame.size.height * (-1);
	}
	else {
		self.affiliationAbstractSpacingLayoutConstraint.constant = self.affiliationAbstractSpacingConstraintInitialConstant;
		self.speakerAffiliationSpacingLayoutConstraint.constant = self.speakerAffiliationSpacingLayoutConstraintInitialConstant;
	}
	
	self.abstractTextView.text = item.abstract;
	self.abstractTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	
	[self setNeedsUpdateConstraints];
	[self updateConstraints];
	
	[self setNeedsLayout];
	[self layoutIfNeeded];
}

@end
