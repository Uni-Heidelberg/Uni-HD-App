//
//  UHDNewsItemCell.m
//  uni-hd
//
//  Created by Kevin Geier on 14.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDNewsItemCell.h"


@implementation UHDNewsItemCell

- (void)awakeFromNib
{
	[super awakeFromNib];
    //self.readBarView.backgroundColor = [UIColor brandColor];
	self.readBarView.textColor = [UIColor brandColor];
	[self layoutIfNeeded];
}

// Override getters to return the respective constraint

- (NSArray *)layoutContraintsWithImage
{
    if (!_layoutContraintsWithImage) {
        UIView *newsImageView = self.newsImageView;
        UIView *abstractLabel = self.abstractLabel;
        self.layoutContraintsWithImage = [NSLayoutConstraint constraintsWithVisualFormat:@"[newsImageView]-8-[abstractLabel]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:NSDictionaryOfVariableBindings(newsImageView, abstractLabel)];
    }
    return _layoutContraintsWithImage;
}

- (NSArray *)layoutContraintsWithoutImage
{
    if (!_layoutContraintsWithoutImage) {
        self.layoutContraintsWithoutImage = @[ [NSLayoutConstraint constraintWithItem:self.abstractLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.titleLabel attribute:NSLayoutAttributeLeading multiplier:1 constant:0] ];
    }
    return _layoutContraintsWithoutImage;
}

@end
