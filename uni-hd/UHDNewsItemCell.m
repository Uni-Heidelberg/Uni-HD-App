//
//  UHDNewsItemCell.m
//  uni-hd
//
//  Created by Kevin Geier on 14.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDNewsItemCell.h"

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

@implementation UHDNewsItemCell
/*
- (void)layoutSubviews {
    [super layoutSubviews];
}
*/


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

