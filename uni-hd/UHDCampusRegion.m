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
@dynamic overlayBottomLeftCoordinateLat,overlayBottomLeftCoordinateLong, overlayBottomRightCoordinateLat, overlayBottomRightCoordinateLong, overlayTopLeftCoordinateLat, overlayTopLeftCoordinateLong, overlayTopRightCoordinateLat, overlayTopRightCoordinateLong;
@dynamic render;
@synthesize boundingMapRect;
@synthesize coordinate;
@dynamic longitude, latitude;

-(CLLocationCoordinate2D)midCoordinate{
    
    return CLLocationCoordinate2DMake(self.latitude, self.longitude);
    
}

-(CLLocationCoordinate2D)overlayTopLeftCoordinate{
    
    return CLLocationCoordinate2DMake(self.overlayTopLeftCoordinateLat, self.overlayTopLeftCoordinateLong);
    
}

-(CLLocationCoordinate2D)overlayTopRightCoordinate{
    
    return CLLocationCoordinate2DMake(self.overlayTopRightCoordinateLat, self.overlayTopRightCoordinateLong);
    
}

-(CLLocationCoordinate2D)overlayBottomLeftCoordinate{
    
    return CLLocationCoordinate2DMake(self.overlayBottomLeftCoordinateLat, self.overlayBottomLeftCoordinateLong);
    
}

-(CLLocationCoordinate2D)overlayBottomRightCoordinate{
    
    return CLLocationCoordinate2DMake(self.overlayBottomRightCoordinateLat, self.overlayBottomRightCoordinateLong);
    
}

- (MKMapRect)overlayBoundingMapRect {
    
    MKMapPoint topLeft = MKMapPointForCoordinate(self.overlayTopLeftCoordinate);
    MKMapPoint topRight = MKMapPointForCoordinate(self.overlayTopRightCoordinate);
    MKMapPoint bottomRight = MKMapPointForCoordinate(self.overlayBottomRightCoordinate);
    
    return MKMapRectMake(topLeft.x,
                         topLeft.y,
                         fabs(topLeft.x - topRight.x),
                         fabs(topRight.y - bottomRight.y));
}

- (instancetype)initWithRegion:(UHDCampusRegion *)campusRegion {
    self = [super init];
    if (self) {
        boundingMapRect = self.overlayBoundingMapRect;
        coordinate = self.midCoordinate;
    }
    
    return self;
}



#pragma mark - Mutable To-Many Accessors

- (NSMutableSet *)mutableBuildings
{
    return [self mutableSetValueForKey:@"buildings"];
}



@end
