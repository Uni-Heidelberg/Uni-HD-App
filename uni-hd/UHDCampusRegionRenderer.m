//
//  UHDCampusRegionRenderer.m
//  uni-hd
//
//  Created by Andreas Schachner on 03.09.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDCampusRegionRenderer.h"
#import "UHDCampusRegion.h"

@implementation UHDCampusRegionRenderer

- (instancetype)initWithCampusRegion:(UHDCampusRegion *)campusRegion{
    self = [super initWithOverlay:campusRegion];
    if (self) {
        self.overlayImage = [UIImage imageNamed:campusRegion.identifier];
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





@end
