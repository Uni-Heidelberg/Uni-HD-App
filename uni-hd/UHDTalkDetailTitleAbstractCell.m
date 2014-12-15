//
//  UHDTalkDetailTitleCell.m
//  uni-hd
//
//  Created by Kevin Geier on 12.12.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDTalkDetailTitleAbstractCell.h"

@interface UHDTalkDetailTitleAbstractCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *speakerButton;
@property (weak, nonatomic) IBOutlet UILabel *affiliationLabel;
@property (weak, nonatomic) IBOutlet UILabel *abstractLabel;

@end

@implementation UHDTalkDetailTitleAbstractCell

- (void)configureForItem:(UHDTalkItem *)item {

	self.titleLabel.text = item.title;
	[self.speakerButton setTitle:item.speaker.name forState:UIControlStateNormal];
	self.affiliationLabel.text = item.speaker.affiliation;
	self.abstractLabel.text = item.abstract;

}

@end
