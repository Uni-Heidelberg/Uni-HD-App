//
//  UHDMensa.m
//  uni-hd
//
//  Created by Felix on 14.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDMensa.h"
#import "UHDMensaSection.h"
#import "UHDBuilding.h"

@implementation UHDMensa

@dynamic isFavourite;
@dynamic sections;


#pragma mark - Mutable To-Many Accessors

- (NSMutableSet *)mutableSections
{
    return [self mutableSetValueForKey:@"sections"];
}


#pragma mark -. Computed Properties

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
