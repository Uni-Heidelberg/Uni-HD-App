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
    
    // Configure read-Bar
    if (item.read) {
        self.readBarView.hidden = YES;
    }
    else {
        self.readBarView.hidden = NO;
        self.readBarView.backgroundColor = [UIColor brandColor];
    }
    
    // Configure Image
    UIImage* image = [UIImage imageWithData:item.thumb];
    
    if (image != nil) {
        self.newsImageView.hidden = NO;

        // Remove possible prior constraint of NewsItemCell without Image
        [self.abstractLabel.superview removeConstraint:self.abstractLabelLeadingSpaceToSuperviewConstraint];

        // Set constraints for NewsItemCell with image
        [self.abstractLabel.superview addConstraint: self.abstractLabelHorizontalSpacingToImageViewConstraint];
        [self.abstractLabel.superview addConstraint:self.abstractLabelProportionalWidthToImageViewConstraint];

        self.newsImageView.image = image;
    }
    else {
        self.newsImageView.hidden = YES;

        // Remove possible prior constraints of NewsItemCell with image
        [self.abstractLabel.superview removeConstraint:self.abstractLabelLeadingSpaceToSuperviewConstraint];
        [self.abstractLabel.superview removeConstraint:self.abstractLabelProportionalWidthToImageViewConstraint];

        // Set constraint for NewsItemCell without image
        [self.abstractLabel.superview addConstraint:self.abstractLabelLeadingSpaceToSuperviewConstraint];

    }
}

@end
