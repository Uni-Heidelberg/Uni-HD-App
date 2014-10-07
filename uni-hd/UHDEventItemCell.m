//
//  UHDEventItemCell.m
//  uni-hd
//
//  Created by Kevin Geier on 07.07.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDEventItemCell.h"

@implementation UHDEventItemCell

- (void)awakeFromNib {
	[super awakeFromNib];
	
	// fixes multiline label autolayout issue that layout is only updated when cell is dequeued
	[self layoutIfNeeded];
}

@end
