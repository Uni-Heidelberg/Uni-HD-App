//
//  UHDCampusRegion.m
//  uni-hd
//
//  Created by Andreas Schachner on 27.08.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

MKMapRect MKMapRectForCoordinateRegion(MKCoordinateRegion region)
{
    MKMapPoint a = MKMapPointForCoordinate(CLLocationCoordinate2DMake(region.center.latitude + region.span.latitudeDelta / 2, region.center.longitude - region.span.longitudeDelta / 2));
    MKMapPoint b = MKMapPointForCoordinate(CLLocationCoordinate2DMake(region.center.latitude - region.span.latitudeDelta / 2, region.center.longitude + region.span.longitudeDelta / 2));
    return MKMapRectMake(MIN(a.x, b.x), MIN(a.y, b.y), ABS(a.x - b.x), ABS(a.y - b.y));
}

#import "UHDCampusRegion.h"

@implementation UHDCampusRegion

@dynamic title, identifier;
@dynamic buildings;
@dynamic centerLongitude, centerLatitude, deltaLatitude, deltaLongitude;


# pragma mark - Computed Properties

- (MKCoordinateRegion)coordinateRegion {
    return MKCoordinateRegionMake(CLLocationCoordinate2DMake(self.centerLatitude, self.centerLongitude), MKCoordinateSpanMake(self.deltaLatitude, self.deltaLongitude));
}


#pragma mark - MKOverlay

- (MKMapRect)boundingMapRect {
    return MKMapRectForCoordinateRegion(self.coordinateRegion);
}

- (CLLocationCoordinate2D)coordinate {
    return self.coordinateRegion.center;
}


#pragma mark - Mutable To-Many Accessors

- (NSMutableSet *)mutableBuildings
{
    return [self mutableSetValueForKey:@"buildings"];
}



@end
