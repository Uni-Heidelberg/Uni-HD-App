//
//  UHDCampusRegion.m
//  uni-hd
//
//  Created by Andreas Schachner on 27.08.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//


#import "UHDCampusRegion.h"

@implementation UHDCampusRegion

@dynamic identifier;
@dynamic buildings;
@dynamic spanLatitude, spanLongitude;


# pragma mark - Computed Properties

- (MKCoordinateRegion)coordinateRegion {
    return MKCoordinateRegionMake(self.coordinate, MKCoordinateSpanMake(self.spanLatitude, self.spanLongitude));
}


#pragma mark - MKOverlay Protocol

- (MKMapRect)boundingMapRect {
    return MKMapRectForCoordinateRegion(self.coordinateRegion);
}


#pragma mark - Mutable To-Many Accessors

- (NSMutableSet *)mutableBuildings
{
    return [self mutableSetValueForKey:@"buildings"];
}



@end
