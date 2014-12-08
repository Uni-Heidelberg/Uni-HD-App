//
//  UHDNewsItem.m
//  uni-hd
//
//  Created by Kevin Geier on 14.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDNewsItem.h"

@interface UHDNewsItem ()

@property (nonatomic) NSDate *primitiveDate;
@property (nonatomic) NSString *primitiveSectionIdentifier;

@end


@implementation UHDNewsItem

@dynamic title;
@dynamic date;
@dynamic abstract;
@dynamic read;
@dynamic url;
@dynamic thumbImageData;
@dynamic source;
@dynamic sectionIdentifier;

@dynamic primitiveDate, primitiveSectionIdentifier;


#pragma mark - Convenience accessors

- (UIImage *)thumbImage
{
    // TODO: cache in property, but figure out correct way to overwrite core data setter method first
    return [UIImage imageWithData:self.thumbImageData];
}


- (void)setThumbImage:(UIImage *)thumbImage
{
    self.thumbImageData = UIImageJPEGRepresentation(thumbImage, 1);
}


# pragma mark - Sectioning


- (NSString *)sectionIdentifier {
	
	// Create and cache the section identifier on demand.

    [self willAccessValueForKey:@"sectionIdentifier"];
    NSString *tmp = [self primitiveSectionIdentifier];
    [self didAccessValueForKey:@"sectionIdentifier"];
	
	//Format of the identifier string: @"YYYYMMSS", where the last two digits "SS" are a number of the enum type UHDSectioningPeriod. This format ensures that the section names are always in a chronological order.

    if (!tmp) {
	
		NSCalendar *calendar = [NSCalendar currentCalendar];
		NSDate *date = [calendar dateBySettingHour:0 minute:0 second:0 ofDate:self.date options:0];
		NSDate *today = [calendar dateBySettingHour:0 minute:0 second:0 ofDate:[NSDate date] options:0];
		NSInteger daysFromNow = [calendar components:NSCalendarUnitDay fromDate:today toDate:date options:0].day;

		NSDateComponents *dateComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:date];
		NSDateComponents *currentDateComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:today];
		
		NSInteger monthOfDateID = dateComponents.year * 100 * 100 + dateComponents.month * 100;
		NSInteger currentMonthID = currentDateComponents.year * 100 * 100 + currentDateComponents.month * 100;

		switch (daysFromNow) {
			case 0:
				tmp = [NSString stringWithFormat:@"%ld", currentMonthID + UHDSectioningPeriodToday];
				break;
			case 1:
				tmp = [NSString stringWithFormat:@"%ld", currentMonthID + UHDSectioningPeriodTomorrow];
				break;
			case -1:
				tmp = [NSString stringWithFormat:@"%ld", currentMonthID + UHDSectioningPeriodYesterday];
				break;
			default:
				if (daysFromNow > 7) {
					if ( (dateComponents.year == currentDateComponents.year) && (dateComponents.month == currentDateComponents.month) ) {
						tmp = [NSString stringWithFormat:@"%ld", currentMonthID + UHDSectioningPeriodLater];
					}
					else {
						tmp = [NSString stringWithFormat:@"%ld", monthOfDateID];
					}
				}
				else if (daysFromNow > 0) {
					tmp = [NSString stringWithFormat:@"%ld", currentMonthID + UHDSectioningPeriodNext7days];
				}
				else if (daysFromNow >= -7) {
					tmp = [NSString stringWithFormat:@"%ld", currentMonthID + UHDSectioningPeriodLast7days];
				}
				else {
					if ( (dateComponents.year == currentDateComponents.year) && (dateComponents.month == currentDateComponents.month) ) {
						tmp = [NSString stringWithFormat:@"%ld", currentMonthID + UHDSectioningPeriodEarlier];
					}
					else {
						tmp = [NSString stringWithFormat:@"%ld", monthOfDateID];
					}
				}
		}
		
		[self setPrimitiveSectionIdentifier:tmp];
	}
	
	return tmp;
}


- (void)setDate:(NSDate *)newDate
{
    // If the date changes, the section identifier becomes invalid.
    [self willChangeValueForKey:@"date"];
    [self setPrimitiveDate:newDate];
    [self didChangeValueForKey:@"date"];

    [self setPrimitiveSectionIdentifier:nil];
}


+ (NSSet *)keyPathsForValuesAffectingSectionIdentifier
{
    // If the value of date changes, the section identifier may change as well.
    return [NSSet setWithObject:@"date"];
}

@end