//
//  UHDTalkDetailPlaceTimeCell.m
//  uni-hd
//
//  Created by Kevin Geier on 12.12.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDTalkDetailSpaceTimeCell.h"

@interface UHDTalkDetailSpaceTimeCell ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIButton *addToCalendarButton;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end


@implementation UHDTalkDetailSpaceTimeCell


-(void)configureForItem:(UHDTalkItem *)item {

	// Configure date and time
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
	[dateFormatter setDateStyle:NSDateFormatterFullStyle];
	self.timeLabel.text = [dateFormatter stringFromDate:item.date];
	
	self.locationLabel.text = item.formattedLocation;
	
	[self.addToCalendarButton setTitle:NSLocalizedString(@"Veranstaltung in den Kalender eintragen", nil) forState:UIControlStateNormal];

}


@end
