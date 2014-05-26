//
//  UHDNewsItemCell+ConfigureForItem.m
//  uni-hd
//
//  Created by Kevin Geier on 14.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDNewsItemCell+ConfigureForItem.h"
#import "UHDNewsSource.h"

@implementation UHDNewsItemCell (ConfigureForItem)

- (void)configureForItem:(UHDNewsItem *)item {
    
    // Configure text
    self.titleLabel.text = item.title;
    self.abstractLabel.text = item.abstract;
    self.sourceLabel.text = item.source.title;
    
    // Configure date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.yyyy"];
    
    self.dateLabel.text = [dateFormatter stringFromDate:item.date];
    
    // Configure Image
    UIImage* image = [UIImage imageWithData:item.thumb];
    
    if (image != nil) {
        self.newsImage.hidden = FALSE;
        
        // Remove possible prior constraint of NewsItemCell without Image
        [self.titleLabel.superview removeConstraint:self.titleLabelLeadingSpaceToSuperviewConstraint];

        // Set constraints for NewsItemCell with image
        [self.titleLabel.superview addConstraint: self.titleLabelSpacingToImageViewConstraint];
        [self.titleLabel.superview addConstraint:self.titleLabelImageViewWidthConstraint];
        
        self.newsImage.image = image;
    }
    else {
        self.newsImage.hidden = TRUE;
        
        // Remove possible prior constraints of NewsItemCell with image
        [self.titleLabel.superview removeConstraint:self.titleLabelLeadingSpaceToSuperviewConstraint];
        [self.titleLabel.superview removeConstraint:self.titleLabelImageViewWidthConstraint];

        // Set constraint for NewsItemCell without image
        [self.titleLabel.superview addConstraint:self.titleLabelLeadingSpaceToSuperviewConstraint];
    }
}

@end
