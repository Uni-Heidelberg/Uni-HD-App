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
@dynamic currentDistance;

// TODO: implement attributes with relationships to maps module
- (NSString *)buildingNumber {
    return nil;
}
- (void)setBuildingNumber:(NSString *)buildingNumber {
    return;
}
- (UHDCampusRegion *)campusRegion {
    return nil;
}
- (void)setCampusRegion:(UHDCampusRegion *)campusRegion {
    return;
}
- (UHDLocationCategory *)category {
    return nil;
}
- (void)setCategory:(UHDLocationCategory *)category {
    return;
}
- (NSString *)identifier {
    return self.title;
}

#pragma mark - Mutable To-Many Accessors

- (NSMutableSet *)mutableMenus
{
    return [self mutableSetValueForKey:@"menus"];
}
- (NSMutableSet *)mutableSections
{
    return [self mutableSetValueForKey:@"sections"];
}


#pragma mark - Computed Properties

- (Hours *)hours {
    return [[Hours alloc] init];
}

- (NSAttributedString *)attributedStatusDescription {
    NSMutableAttributedString *attributedStatusDescription = [[NSMutableAttributedString alloc] initWithAttributedString:self.hours.attributedDescription];
    if (self.currentDistance >= 0) {
        MKDistanceFormatter *distanceFormatter = [[MKDistanceFormatter alloc] init];
        [attributedStatusDescription appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@", %@ entfernt", [distanceFormatter stringFromDistance:self.currentDistance]]]];
    }
    return attributedStatusDescription;
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
