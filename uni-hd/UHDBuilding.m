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
@dynamic imageData, relativeImageURL;
@dynamic spanLatitude, spanLongitude;


#pragma mark - Computed Properties

- (NSString *)campusIdentifier {
    return [NSString stringWithFormat:@"%@ %@", self.campusRegion.identifier, self.buildingNumber];
}

- (NSURL *)imageURL {
    if (self.relativeImageURL) {
        return [[NSURL URLWithString:@"http://appserver.physik.uni-heidelberg.de"] URLByAppendingPathComponent:self.relativeImageURL.path]; // TODO: use constant
    } else {
        return nil;
    }
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
