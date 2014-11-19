//
//  UHDBuilding.m
//  uni-hd
//
//  Created by Andreas Schachner on 07.08.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDBuilding.h"

#import "UHDCampusRegion.h"

@implementation UHDBuilding

@dynamic category;
@dynamic campusRegion, buildingNumber;
@dynamic addressDictionary;
@dynamic imageData;
@dynamic spanLatitude, spanLongitude;


#pragma mark - Computed Properties

- (NSString *)campusIdentifier {
    return [NSString stringWithFormat:@"%@ %@", self.campusRegion.identifier, self.buildingNumber];
}

- (UIImage *)image {
    return [UIImage imageWithData:self.imageData];
}

- (void)setImage:(UIImage *)image {
    self.imageData = UIImageJPEGRepresentation(image, 1);
}

- (MKCoordinateRegion)coordinateRegion {
    return MKCoordinateRegionMake(self.coordinate, MKCoordinateSpanMake(self.spanLatitude, self.spanLongitude));
}

- (void)setCoordinateRegion:(MKCoordinateRegion)coordinateRegion {
    self.coordinate = coordinateRegion.center;
    self.spanLatitude = coordinateRegion.span.latitudeDelta;
    self.spanLongitude = coordinateRegion.span.longitudeDelta;
}

#pragma mark - MKAnnotation Protocol

// mostly inherited from UHDRemoteManagedLocation

- (NSString *)subtitle {
    return self.campusIdentifier;
}

#pragma mark - MKOverlay Protocol

- (MKMapRect)boundingMapRect {
    return MKMapRectForCoordinateRegion(self.coordinateRegion);
}


@end
