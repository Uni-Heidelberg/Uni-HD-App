//
//  UHDEventItemCell.m
//  uni-hd
//
//  Created by Kevin Geier on 07.07.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDEventItemCell.h"
#import "UHDNewsSource.h"

@interface UHDEventItemCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *abstractLabel;
@property (weak, nonatomic) IBOutlet UIImageView *eventImageView;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *eventIndicatorView;
@property (weak, nonatomic) IBOutlet UILabel *shortDateAndTimeLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageSpacingLayoutConstraint;
@property (nonatomic) CGFloat imageSpacingConstraintInitialConstant;

@end


@implementation UHDEventItemCell

- (void)awakeFromNib {
	[super awakeFromNib];
	self.imageSpacingConstraintInitialConstant = self.imageSpacingLayoutConstraint.constant;
}

-(void)configureForItem:(UHDEventItem *)item
{
    // Configure text
    self.titleLabel.text = item.title;
    self.locationLabel.text = item.location;
    self.abstractLabel.text = item.abstract;
	self.sourceLabel.text = item.source.title;
    
    // Configure date and time
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
	[calendar setTimeZone:timeZone];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setCalendar:calendar];
	/*
	NSString *formatTemplate = [NSDateFormatter dateFormatFromTemplate:@"MMMM YYYY" options:0 locale:[NSLocale currentLocale]];
	[dateFormatter setDateFormat:formatTemplate];
	*/
	[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	self.shortDateAndTimeLabel.text = [dateFormatter stringFromDate:item.date];
	
	// Configure indicator
	if (item.read) {
        self.eventIndicatorView.tintColor = [UIColor lightGrayColor];
	} else {
        self.eventIndicatorView.tintColor = [UIColor brandColor];
	}
    
    // Configure image
    self.eventImageView.image = item.thumbImage;
	if (item.thumbImage) {
		self.imageSpacingLayoutConstraint.constant = self.imageSpacingConstraintInitialConstant;
	} else {
		self.imageSpacingLayoutConstraint.constant = 0;
	}
	
    // Layout multiline labels for updated content
    [self layoutIfNeeded];
}

@end
