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
    self.titleLabel.text = item.title;
    self.abstractLabel.text = item.abstract;
    self.sourceLabel.text = item.source.title;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.yyyy"];
    
    self.dateLabel.text = [dateFormatter stringFromDate:item.date];
    
    UIImage* image = [UIImage imageWithData:item.thumb];
    
    if (image != nil) {
        [self.titleLabel.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.newsImage attribute:NSLayoutAttributeTrailing multiplier:1 constant:8]];
        
        [self.titleLabel.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.newsImage attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.titleLabel attribute:NSLayoutAttributeWidth multiplier:0.5 constant:0]];
        
        self.newsImage.image = image;
        }
    else {
        [self.newsImage removeFromSuperview];
        
        [self.titleLabel.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.titleLabel.superview attribute:NSLayoutAttributeLeading multiplier:1 constant:8]];
        }
    }

@end
