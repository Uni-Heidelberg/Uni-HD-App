//
//  UHDMensa.m
//  uni-hd
//
//  Created by Felix on 14.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDMensa.h"
#import "UHDMensaSection.h"

@implementation UHDMensa

@dynamic isFavourite;
@dynamic currentDistance;
@dynamic sections;

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
- (UHDAddress *)address {
    return nil;
}
- (void)setAddress:(UHDAddress *)address {
    return;
}

#pragma mark - Mutable To-Many Accessors

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

- (BOOL)hasMenuForDate:(NSDate *)date
{
    for (UHDMensaSection *section in self.sections) {
        if ([section dailyMenuForDate:date]) return YES;
    }
    return NO;
}

@end
