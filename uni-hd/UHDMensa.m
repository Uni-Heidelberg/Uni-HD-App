//
//  UHDMensa.m
//  uni-hd
//
//  Created by Felix on 14.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDMensa.h"
#import "UHDDailyMenu.h"


@implementation UHDMensa

@dynamic menus;
@dynamic sections;
@dynamic isFavourite;
@dynamic imageName;

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



@end
