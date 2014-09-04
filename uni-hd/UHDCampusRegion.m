//
//  UHDCampusRegion.m
//  uni-hd
//
//  Created by Andreas Schachner on 27.08.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDCampusRegion.h"

@implementation UHDCampusRegion

@dynamic title, identifier;
@dynamic buildings;
@synthesize boundingMapRect;
@synthesize coordinate;
@dynamic centerLongitude, centerLatitude, deltaLatitude, deltaLongitude;

-(MKMapRect)boundingMapRect{
    
    return MKMapRectMake(self.centerLatitude - self.deltaLatitude / 2, self.centerLongitude - self.deltaLongitude / 2, self.deltaLatitude, self.deltaLongitude);
    
}

-(CLLocationCoordinate2D)coordinate{
    
    return CLLocationCoordinate2DMake(self.centerLatitude, self.centerLongitude);
    
}

#pragma mark - Mutable To-Many Accessors

- (NSMutableSet *)mutableBuildings
{
    return [self mutableSetValueForKey:@"buildings"];
}



@end
