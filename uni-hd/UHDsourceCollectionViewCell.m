//
//  UHDsourceCollectionViewCell.m
//  uni-hd
//
//  Created by Kevin Geier on 07.11.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDSourceCollectionViewCell.h"
#import "UHDNewsSourcesNavigationBar.h"

@implementation UHDSourceCollectionViewCell

- (void)layoutSubviews {
	[super layoutSubviews];
	
	// configure circular Image View
	self.sourceIconImageView.layer.cornerRadius = self.sourceIconImageView.bounds.size.height / 2;
	self.sourceIconImageView.layer.masksToBounds = YES;
}

@end