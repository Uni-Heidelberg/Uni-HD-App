//
//  UHDBuilding.m
//  uni-hd
//
//  Created by Andreas Schachner on 07.08.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDBuilding.h"

#import "UHDCampusRegion.h"
#import "UHDAddress.h"

@implementation UHDBuilding

@dynamic category;
@dynamic campusRegion, buildingNumber;
@dynamic imageData, imageURL;
@dynamic spanLatitude, spanLongitude;
@dynamic address;
@dynamic telephone, email, url;
@dynamic associatedNewsSources;


- (NSMutableSet *)mutableAssociatedNewsSources {
    return [self mutableSetValueForKey:@"associatedNewsSources"];
}

#pragma mark - Computed Properties

- (NSString *)campusIdentifier {
    if (self.campusRegion && self.buildingNumber) {
        return [NSString stringWithFormat:@"%@ %@", self.campusRegion.identifier, self.buildingNumber];
    } else {
        return nil;
    }
}

- (Hours *)hours {
    return nil;
}

- (UIImage *)image
{
    if (self.imageData) {
        return [UIImage imageWithData:self.imageData];
    } else if (self.imageURL) {
        NSURLRequest *request = [NSURLRequest requestWithURL:self.imageURL cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if ([(NSHTTPURLResponse *)response statusCode]==200) {
                self.imageData = data;
            }
        }];
        return nil;
    } else {
        return nil;
    }
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

- (MKMapItem *)mapItem {
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:self.coordinate addressDictionary:self.address.addressDictionary]];
    mapItem.name = self.title ? self.title : self.campusIdentifier;
    return mapItem;
}

- (NSArray *)upcomingEvents {
    return [[self.events filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"date > %@", [NSDate date]]] sortedArrayUsingDescriptors:@[ [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES] ]];
}

#pragma mark - MKAnnotation Protocol

// mostly inherited from UHDRemoteManagedLocation

- (NSString *)title {
    if ([self primitiveValueForKey:@"title"]) {
        return [self primitiveValueForKey:@"title"];
    } else {
        return self.campusIdentifier;
    }
}

- (NSString *)subtitle {
    return self.campusIdentifier;
}

#pragma mark - MKOverlay Protocol

- (MKMapRect)boundingMapRect {
    return MKMapRectForCoordinateRegion(self.coordinateRegion);
}


@end
