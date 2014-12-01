//
//  UHDMensaSection.m
//  uni-hd
//
//  Created by Felix on 14.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDMensaSection.h"
#import "UHDMeal.h"


@implementation UHDMensaSection

@dynamic title;
@dynamic menus;
@dynamic mensa;

#pragma mark - Mutable To-Many Accessors

- (NSMutableSet *)mutableMenus
{
    return [self mutableSetValueForKey:@"menus"];
}

#pragma mark - Convenience Methods

- (UHDDailyMenu *)dailyMenuForDate:(NSDate *)date
{
    NSDate *startDate;
    NSTimeInterval dayLength;
    [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay startDate:&startDate interval:&dayLength forDate:date];
    NSDate *endDate = [startDate dateByAddingTimeInterval:dayLength];
    
    return [[self.menus filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"(date >= %@) AND (date < %@)", startDate, endDate]] anyObject];
}

@end
