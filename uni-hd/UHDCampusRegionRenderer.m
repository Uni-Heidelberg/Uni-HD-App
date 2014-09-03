//
//  UHDCampusRegionRenderer.m
//  uni-hd
//
//  Created by Andreas Schachner on 03.09.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDCampusRegionRenderer.h"

@implementation UHDCampusRegionRenderer

@dynamic overlayImage;
//@dynamic imageData;

- (instancetype)initWithOverlay:(id<MKOverlay>)overlay overlayImage:(UIImage *)overlayImage {
    self = [super initWithOverlay:overlay];
    if (self) {
        self.overlayImage = overlayImage;
    }
    
    return self;
}

- (void)drawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale inContext:(CGContextRef)context {
    
    CGImageRef imageReference = self.overlayImage.CGImage;
    
    MKMapRect theMapRect = self.overlay.boundingMapRect;
    CGRect theRect = [self rectForMapRect:theMapRect];
    
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextTranslateCTM(context, 0.0, -theRect.size.height);
    CGContextDrawImage(context, theRect, imageReference);
}

- (MKMapRect)overlayBoundingMapRect {
    
    MKMapPoint topLeft = MKMapPointForCoordinate(self.campusRegion.overlayTopLeftCoordinate);
    MKMapPoint topRight = MKMapPointForCoordinate(self.campusRegion.overlayTopRightCoordinate);
    MKMapPoint bottomLeft = MKMapPointForCoordinate(self.campusRegion.overlayBottomLeftCoordinate);
    
    return MKMapRectMake(topLeft.x,
                         topLeft.y,
                         fabs(topLeft.x - topRight.x),
                         fabs(topLeft.y - bottomLeft.y));
}

/*
- (UIImage *)overlayImage {
    return [UIImage imageWithData:self.imageData];
}

- (void)setImage:(UIImage *)image {
    self.imageData = UIImageJPEGRepresentation(image, 1);
}
*/
@end
