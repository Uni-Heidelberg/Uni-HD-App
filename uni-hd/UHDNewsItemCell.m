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
    self.sourceLabel.text = item.source.title;
	self.abstractLabel.text = item.abstract;
    
    // Configure date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    self.dateLabel.text = [dateFormatter stringFromDate:item.date];
    
    // Configure read indication
	if (item.read) {
		self.titleLabel.textColor = [UIColor lightGrayColor];
		self.sourceLabel.textColor = [UIColor lightGrayColor];
		self.dateLabel.textColor = [UIColor lightGrayColor];
		self.abstractLabel.textColor = [UIColor lightGrayColor];
		self.sourceIconImageView.alpha = 0.5;
		self.newsImageView.alpha = 0.5;
	}
	else {
		self.titleLabel.textColor = [UIColor blackColor];
		self.sourceLabel.textColor = [UIColor darkGrayColor];
		self.dateLabel.textColor = [UIColor darkGrayColor];
		self.abstractLabel.textColor = [UIColor darkGrayColor];
		self.sourceIconImageView.alpha = 1.0;
		self.newsImageView.alpha = 1.0;
	}
    
    // Configure Image
	self.sourceIconImageView.image = item.source.image;
    self.newsImageView.image = item.image;
	if (self.newsImageView.image) {
		self.imageSpacingLayoutConstraint.constant = self.imageSpacingConstraintInitialConstant;
	} else {
		self.imageSpacingLayoutConstraint.constant = 0;
	}
	[self setNeedsUpdateConstraints];
	[self updateConstraintsIfNeeded];
	
	// layout multiline labels for updated content
	[self setNeedsLayout];
	[self layoutIfNeeded];
}

@end
