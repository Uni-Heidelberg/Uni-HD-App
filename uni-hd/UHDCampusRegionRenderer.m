//
//  UHDCampusRegionRenderer.m
//  uni-hd
//
//  Created by Andreas Schachner on 03.09.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDCampusRegionRenderer.h"


@interface UHDCampusRegionRenderer ()

@property (strong, nonatomic) UIImage *overlayImage;

@property (nonatomic) double_t angle;

@end


@implementation UHDCampusRegionRenderer

- (instancetype)initWithCampusRegion:(UHDCampusRegion *)campusRegion
{
    if ((self = [super initWithOverlay:campusRegion])) {
        self.overlayImage = [UIImage imageNamed:campusRegion.identifier];
        self.angle = campusRegion.overlayAngle;
    }
    
    return self;
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
    CGContextRotateCTM(context, self.angle);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextTranslateCTM(context, 0.0, -imageRect.size.height);
    CGContextDrawImage(context, imageRect, self.overlayImage.CGImage);
    
}





@end
