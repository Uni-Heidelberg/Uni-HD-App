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
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    self.dateLabel.text = [dateFormatter stringFromDate:item.date];
    
    // Configure read indicator
    self.readIndicatorContainerView.hidden = item.read;
	
    //self.backgroundColor = item.read ? [UIColor whiteColor] : [UIColor colorWithWhite:0.97 alpha:1];
    
    // Configure Image
    UIImage *image = item.thumbImage;
    self.newsImageView.image = image;
    self.newsImageView.hidden = image==nil;
    [self.contentView removeConstraints:image==nil ? self.layoutContraintsWithImage : self.layoutContraintsWithoutImage];
    [self.contentView addConstraints:image==nil ? self.layoutContraintsWithoutImage : self.layoutContraintsWithImage];
    
    // trigger layout update to make multiline labels aware of changed text lengths
    [self setNeedsLayout];
}

@end
