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

// Experimentally:

/*
- (NSString *)sectionIdentifier {
	
	// Create and cache the section identifier on demand.

    [self willAccessValueForKey:@"sectionIdentifier"];
    NSString *tmp = [self primitiveSectionIdentifier];
    [self didAccessValueForKey:@"sectionIdentifier"];

    if (!tmp) {
	
		NSCalendar *calendar = [NSCalendar currentCalendar];
		
		NSDate *reducedDate = [calendar dateBySettingHour:0 minute:0 second:0 ofDate:self.date options:0];
		NSDate *today = [calendar dateBySettingHour:0 minute:0 second:0 ofDate:[NSDate date] options:0];
		
		NSInteger daysFromNow = [calendar components:NSCalendarUnitDay fromDate:today toDate:reducedDate options:0].day;

		NSDateComponents *reducedDateComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:reducedDate];
		
		NSInteger currentMonth = [calendar component:NSCalendarUnitMonth fromDate:today];


		switch (daysFromNow) {
			case 0:
				tmp = @"today";
				//tmp = [NSString stringWithFormat:@"%ld", ([reducedDateComponents year] * 10000) + currentMonth * 100 + 21];
				break;
			case 1:
				tmp = @"tomorrow";
				//tmp = [NSString stringWithFormat:@"%ld", ([reducedDateComponents year] * 10000) + currentMonth * 100 + 22];
				break;
			case -1:
				tmp = @"yesterday";
				//tmp = [NSString stringWithFormat:@"%ld", ([reducedDateComponents year] * 10000) + currentMonth * 100 + 20];
				break;
			default:
				if (daysFromNow > 7) {
					if (reducedDateComponents.month == currentMonth) {
						tmp = [NSString stringWithFormat:@"%ld", ([reducedDateComponents year] * 10000) + [reducedDateComponents month] * 100 + 90];
					}
					else {
						tmp = [NSString stringWithFormat:@"%ld", ([reducedDateComponents year] * 10000) + currentMonth * 100];
					}
				}
				else if (daysFromNow > 0) {
					tmp = [NSString stringWithFormat:@"%ld", ([reducedDateComponents year] * 10000) + currentMonth * 100 + 30];
				}
				else if (daysFromNow >= -7) {
					tmp = [NSString stringWithFormat:@"%ld", ([reducedDateComponents year] * 10000) + currentMonth * 100 + 10];
				}
				else {
					tmp = [NSString stringWithFormat:@"%ld", ([reducedDateComponents year] * 10000) + [reducedDateComponents month]];
				}
		
		[self setPrimitiveSectionIdentifier:tmp];
	}
	
	return tmp;
}
*/

- (NSString *)sectionIdentifier {
	
	// Create and cache the section identifier on demand.

    [self willAccessValueForKey:@"sectionIdentifier"];
    NSString *tmp = [self primitiveSectionIdentifier];
    [self didAccessValueForKey:@"sectionIdentifier"];

    if (!tmp) {
	
		NSCalendar *calendar = [NSCalendar currentCalendar];
		
		NSDate *reducedDate = [calendar dateBySettingHour:0 minute:0 second:0 ofDate:self.date options:0];
		NSDate *today = [calendar dateBySettingHour:0 minute:0 second:0 ofDate:[NSDate date] options:0];
		
		NSInteger daysFromNow = [calendar components:NSCalendarUnitDay fromDate:today toDate:reducedDate options:0].day;

		switch (daysFromNow) {
			case 0:
				tmp = @"today";
				break;
			case 1:
				tmp = @"tomorrow";
				break;
			case -1:
				tmp = @"yesterday";
				break;
			default:
				if (ABS(daysFromNow) > 7) {
					/*
					Sections are organized by month and year. Create the section identifier as a string representing the number (year * 1000) + month; this way they will be correctly ordered chronologically regardless of the actual name of the month.
					*/
					NSDateComponents *reducedDateComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:reducedDate];
					tmp = [NSString stringWithFormat:@"%ld", ([reducedDateComponents year] * 1000) + [reducedDateComponents month]];
				}
				else {
					if (daysFromNow > 0) {
						tmp = @"next7days";
					}
					else {
						tmp = @"last7days";
					}
				}
		}
		
		[self setPrimitiveSectionIdentifier:tmp];
	}
	
	return tmp;
}


- (void)setDate:(NSDate *)newDate
{
    // If the time stamp changes, the section identifier become invalid.
    [self willChangeValueForKey:@"date"];
    [self setPrimitiveDate:newDate];
    [self didChangeValueForKey:@"date"];

    [self setPrimitiveSectionIdentifier:nil];
}


+ (NSSet *)keyPathsForValuesAffectingSectionIdentifier
{
    // If the value of timeStamp changes, the section identifier may change as well.
    return [NSSet setWithObject:@"date"];
}

@end