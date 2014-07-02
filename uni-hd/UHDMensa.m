//
//  UHDMensa.m
//  uni-hd
//
//  Created by Felix on 14.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDMensa.h"
#import "UHDDailyMenu.h"
#import "UHDLocation.h"


@implementation UHDMensa

@dynamic title;
@dynamic location;
@dynamic menus;
@dynamic sections;

- (NSMutableSet *)mutableMenus
{
    return [self mutableSetValueForKey:@"menus"];
}
- (NSMutableSet *)mutableSections
{
    return [self mutableSetValueForKey:@"sections"];
}


- (UHDDailyMenu *)dailyMenuForDate:(NSDate *)date
{
    NSDate *startDate;
    NSTimeInterval dayLength;
    [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit startDate:&startDate interval:&dayLength forDate:date];
    NSDate *endDate = [startDate dateByAddingTimeInterval:dayLength];
    
    return [[self.menus filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"(date >= %@) AND (date < %@)", startDate, endDate]] anyObject];
}

# pragma mark - MKAnnotation Protocol

- (CLLocationCoordinate2D)coordinate
{
    return self.location.coordinate;
}

@end
