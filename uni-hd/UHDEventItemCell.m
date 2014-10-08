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
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *abstractLabel;
@property (weak, nonatomic) IBOutlet UIImageView *eventImageView;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;

@end


@implementation UHDEventItemCell

- (void)awakeFromNib {
	[super awakeFromNib];
	
	// fixes multiline label autolayout issue that layout is only updated when cell is dequeued
	[self layoutIfNeeded];
}

-(void) configureForItem:(UHDEventItem *)item
{
    // Configure text
    self.titleLabel.text = item.title;
    self.locationLabel.text = item.location;
    self.abstractLabel.text = item.abstract;
	self.sourceLabel.text = item.source.title;
    
    // Configure date and time
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterFullStyle;
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    self.dateLabel.text = [dateFormatter stringFromDate:item.date];
    
    // Configure image
    self.eventImageView.image = item.thumbImage;
    
    // TODO: bad layout after rotatiting back to vertical
	
    // update layout of multiline labels for changed text lengths
    self.titleLabel.preferredMaxLayoutWidth = self.titleLabel.frame.size.width;
    self.dateLabel.preferredMaxLayoutWidth = self.dateLabel.bounds.size.width;
    self.locationLabel.preferredMaxLayoutWidth = self.locationLabel.frame.size.width;
    self.abstractLabel.preferredMaxLayoutWidth = self.abstractLabel.frame.size.width;
    [self layoutIfNeeded];
}

@end
