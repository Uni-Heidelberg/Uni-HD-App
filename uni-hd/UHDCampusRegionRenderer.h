//
//  UHDCampusRegionRenderer.h
//  uni-hd
//
//  Created by Andreas Schachner on 03.09.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import <MapKit/MapKit.h>

@class UHDCampusRegion;

@interface UHDCampusRegionRenderer : MKOverlayRenderer

@property (nonatomic) UHDCampusRegion *campusRegion;
@property (nonatomic) UIImage *overlayImage;

- (instancetype)initWithOverlay:(id<MKOverlay>)overlay overlayImage:(UIImage *)overlayImage;

//@property (nonatomic, retain) NSData *imageData;

@end
