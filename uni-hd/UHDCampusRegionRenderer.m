//
//  UHDCampusRegionRenderer.m
//  uni-hd
//
//  Created by Andreas Schachner on 03.09.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDCampusRegionRenderer.h"


@interface UHDCampusRegionRenderer ()


@end


@implementation UHDCampusRegionRenderer

- (id)initWithOverlay:(UHDCampusRegion *)overlay {
    return [super initWithOverlay:overlay];
}

- (void)drawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale inContext:(CGContextRef)context
{
    CGRect imageRect = [self rectForMapRect:self.overlay.boundingMapRect];
    CGRect tileRect = [self rectForMapRect:mapRect];

    // only draw a tile of the image
    CGContextAddRect(context, tileRect);
    CGContextClip(context);
    
    // set opacity
    CGContextSetAlpha(context, 0.5);

    // draw image
    CGContextRotateCTM(context, self.overlay.overlayAngle);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextTranslateCTM(context, 0.0, -imageRect.size.height);
    CGContextDrawImage(context, imageRect, self.overlay.overlayImage.CGImage);
    
}





@end
