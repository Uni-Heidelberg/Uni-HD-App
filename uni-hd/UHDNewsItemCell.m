//
//  UHDNewsItemCell.m
//  uni-hd
//
//  Created by Kevin Geier on 14.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDNewsItemCell.h"

// Model
#import "UHDNewsSource.h"

// Views
#import "UHDReadIndicatorView.h"


@interface UHDNewsItemCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *abstractLabel;
@property (weak, nonatomic) IBOutlet UIImageView *newsImageView;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sourceIconImageView;

@property (weak, nonatomic) IBOutlet UIView *readIndicatorView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageSpacingLayoutConstraint;
@property (nonatomic) CGFloat imageSpacingConstraintInitialConstant;

@end


@implementation UHDNewsItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imageSpacingConstraintInitialConstant = self.imageSpacingLayoutConstraint.constant;
}

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
	self.readIndicatorView.hidden = item.read;
    
    // Configure Image
	self.sourceIconImageView.image = item.source.image;
    self.newsImageView.image = item.image;
	if (self.newsImageView.image) {
		self.imageSpacingLayoutConstraint.constant = self.imageSpacingConstraintInitialConstant;
	} else {
		self.imageSpacingLayoutConstraint.constant = 0;
	}

    // Layout multiline labels for updated content
    [self layoutIfNeeded];
	
	//[self.logger log:[NSString stringWithFormat:@"Height of symbol: %f", self.readIndicatorImageView.bounds.size.height] forLevel:VILogLevelDebug];
}

@end
