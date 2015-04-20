//
//  UHDTalkDetailLocationCell.m
//  uni-hd
//
//  Created by Kevin Geier on 13.04.15.
//  Copyright (c) 2015 Universit&#228;t Heidelberg. All rights reserved.
//

#import "UHDTalkDetailLocationCell.h"
#import <UHDKit/UHDKit-Swift.h>

@interface UHDTalkDetailLocationCell ()

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@end


@implementation UHDTalkDetailLocationCell

- (void)configureForItem:(UHDTalkItem *)item {

	self.locationLabel.text = item.formattedLocation;
	
	[self setNeedsLayout];
	[self layoutIfNeeded];
}

@end
