//
//  UHDTalkDetailLocationCell.m
//  uni-hd
//
//  Created by Kevin Geier on 13.04.15.
//  Copyright (c) 2015 Universit&#228;t Heidelberg. All rights reserved.
//

#import "UHDTalkDetailLocationCell.h"
@import MapKit;
#import <UHDKit/UHDKit-Swift.h>
#import "UIColor+UHDColors.h"

@interface UHDTalkDetailLocationCell ()

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet CampusMapView *mapView;

@end


@implementation UHDTalkDetailLocationCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureForItem:(UHDTalkItem *)item {

	self.locationLabel.text = item.formattedLocation;
	/*
	UIFontDescriptor *fontDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleBody];
	UIFontDescriptor *boldDescriptor = [fontDescriptor fontDescriptorWithSymbolicTraits:(fontDescriptor.symbolicTraits | UIFontDescriptorTraitBold)];
	self.locationLabel.font = [UIFont fontWithDescriptor:boldDescriptor size:boldDescriptor.pointSize];
	*/
	self.locationLabel.textColor = [UIColor brandColor];

	if (item.location != nil) {
		[self.mapView showLocation:item.location animated:NO];
    }
	
	[self setNeedsLayout];
	[self layoutIfNeeded];
}

@end
