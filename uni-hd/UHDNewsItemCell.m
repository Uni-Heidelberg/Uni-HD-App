//
//  UHDNewsItemCell.m
//  uni-hd
//
//  Created by Kevin Geier on 14.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDNewsItemCell.h"


@implementation UHDNewsItemCell


- (void)updateLabelPreferredMaxLayoutWidthToCurrentWidth
{
    self.titleLabel.preferredMaxLayoutWidth = self.titleLabel.frame.size.width;
    self.dateLabel.preferredMaxLayoutWidth = self.dateLabel.frame.size.width;
    self.abstractLabel.preferredMaxLayoutWidth = self.abstractLabel.frame.size.width;
    self.sourceLabel.preferredMaxLayoutWidth = self.sourceLabel.frame.size.width;
}


// Override getters to return the respective constraint

- (NSLayoutConstraint *)titleLabelSpacingToImageViewConstraint {
    if (!_titleLabelSpacingToImageViewConstraint) {
    
        self.titleLabelSpacingToImageViewConstraint = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.newsImage attribute:NSLayoutAttributeTrailing multiplier:1 constant:8];
        
    }
    return _titleLabelSpacingToImageViewConstraint;
};


- (NSLayoutConstraint *)titleLabelImageViewWidthConstraint {
    if (!_titleLabelImageViewWidthConstraint) {
    
        self.titleLabelImageViewWidthConstraint = [NSLayoutConstraint constraintWithItem:self.newsImage attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.titleLabel attribute:NSLayoutAttributeWidth multiplier:0.5 constant:0];
        
    }
    return _titleLabelImageViewWidthConstraint;
}


- (NSLayoutConstraint *)titleLabelLeadingSpaceToSuperviewConstraint {
    if (!_titleLabelLeadingSpaceToSuperviewConstraint) {
    
        self.titleLabelLeadingSpaceToSuperviewConstraint = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.titleLabel.superview attribute:NSLayoutAttributeLeading multiplier:1 constant:8];
        
    }
    return _titleLabelLeadingSpaceToSuperviewConstraint;
}


@end


// Alternative possible fixes for multiline label issue
/*
@interface MyMultilineLabel : UILabel

@end


@implementation MyMultilineLabel

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    CGFloat width = CGRectGetWidth(bounds);
    if (self.preferredMaxLayoutWidth != width) {
        self.preferredMaxLayoutWidth = width;
    }
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.lineBreakMode = NSLineBreakByWordWrapping;
        self.numberOfLines = 0;
    }
    return self;
}

@end
*/

/*
@implementation UILabel (Multiline)

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    if (bounds.size.width != self.preferredMaxLayoutWidth) {
        self.preferredMaxLayoutWidth = self.bounds.size.width;
    }
}

@end
*/
