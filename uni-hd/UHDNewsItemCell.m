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
	
	UIColor *middleGrayColor = [UIColor colorWithRed:109./255. green:109./255. blue:109./255. alpha:1];
	
	//CGFloat titleFontSize = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline].pointSize;
	
	if (item.read) {
		//self.titleLabel.font = [UIFont systemFontOfSize:titleFontSize];
		self.titleLabel.textColor = middleGrayColor;
		self.sourceLabel.textColor = middleGrayColor;
		self.dateLabel.textColor = middleGrayColor;
		self.abstractLabel.textColor = middleGrayColor;
		self.sourceIconImageView.alpha = 1.0;
		self.newsImageView.alpha = 0.5;
	}
	else {
		//self.titleLabel.font = [UIFont boldSystemFontOfSize:titleFontSize];
		self.titleLabel.textColor = [UIColor blackColor];
		self.sourceLabel.textColor = middleGrayColor;
		self.dateLabel.textColor = middleGrayColor;
		self.abstractLabel.textColor = [UIColor blackColor];
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
