//
//  UHDNewsItem.m
//  uni-hd
//
//  Created by Kevin Geier on 14.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDNewsItem.h"


@implementation UHDNewsItem

@dynamic title;
@dynamic date;
@dynamic abstract;
@dynamic read;
@dynamic url;
@dynamic thumbImageData;
@dynamic source;


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


	/*
	[self willAccessValueForKey:@"simplifiedDate"];
	
	// Use user's current calendar and time zone
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
	[calendar setTimeZone:timeZone];
	
	NSDateComponents *dateComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitYearForWeekOfYear | NSCalendarUnitWeekOfYear fromDate:self.date];
	
	NSDate *simplifiedDate = [calendar dateFromComponents:dateComponents];
	
	[self didAccessValueForKey:@"simplifiedDate"];
	
	return simplifiedDate;*/


/*- (void)setDate:(NSDate *)date {
	
	[self willChangeValueForKey:@"date"];
//	[self willChangeValueForKey:@"simplifiedDate"];
	
	[self setPrimitiveValue:date forKey:@"date"];
	
	[self didChangeValueForKey:@"date"];
//	[self didChangeValueForKey:@"simplifiedDate"];
	
    [self computeDatePeriod];
}*/

@end
