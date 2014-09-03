//
//  UHDCampusRegionRenderer.m
//  uni-hd
//
//  Created by Andreas Schachner on 03.09.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDCampusRegionRenderer.h"

@implementation UHDCampusRegionRenderer

@dynamic campusRegion;

- (instancetype)initWithOverlay:(id<MKOverlay>)overlay overlayImage:(UIImage *)overlayImage {
    self = [super initWithOverlay:overlay];
    if (self) {
        _overlayImage = overlayImage;
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


/*
- (UIImage *)overlayImage {
    return [UIImage imageWithData:self.imageData];
}

- (void)setImage:(UIImage *)image {
    self.imageData = UIImageJPEGRepresentation(image, 1);
}
*/
@end
