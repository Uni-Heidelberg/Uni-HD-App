//
//  UHDTalkItemCell.m
//  uni-hd
//
//  Created by Kevin Geier on 07.07.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDTalkItemCell.h"

@implementation UHDTalkItemCell

- (void)awakeFromNib {
	[super awakeFromNib];
	
	// fixes multiline label autolayout issue that layout is only updated when cell is dequeued
	[self updateConstraints];
	[self updateConstraintsIfNeeded];
	[self setNeedsLayout];
	[self layoutIfNeeded];
}

@end
