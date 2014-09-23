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
#import "UHDRemoteDatasourceManager.h"
#import "UHDMapsRemoteDatasourceDelegate.h"


@interface UHDCampusRegion ()

@property (strong) UIImage *overlayImage;

@end


@implementation UHDCampusRegion

@dynamic identifier;
@dynamic buildings;
@dynamic overlayImageURL, overlayAngle;
@dynamic spanLatitude, spanLongitude;

@synthesize overlayImage = _overlayImage;


# pragma mark - Computed Properties

- (MKCoordinateRegion)coordinateRegion {
    return MKCoordinateRegionMake(self.coordinate, MKCoordinateSpanMake(self.spanLatitude, self.spanLongitude));
}

- (UIImage *)overlayImage {
    // TODO: set nil to trigger reload when overlayImageURL changes
    if (!_overlayImage) {
        self.overlayImage = [(UHDMapsRemoteDatasourceDelegate *)[[UHDRemoteDatasourceManager defaultManager] remoteDatasourceForKey:UHDRemoteDatasourceKeyMaps].delegate overlayImageForUrl:self.overlayImageURL];
    }
    return _overlayImage;
}

- (void)setOverlayImage:(UIImage *)overlayImage {
    _overlayImage = overlayImage;
}


#pragma mark - MKOverlay

- (MKMapRect)boundingMapRect {
    return MKMapRectForCoordinateRegion(self.coordinateRegion);
}


#pragma mark - Mutable To-Many Accessors

- (NSMutableSet *)mutableBuildings
{
    return [self mutableSetValueForKey:@"buildings"];
}



@end
