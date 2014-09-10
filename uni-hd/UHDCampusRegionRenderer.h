//
//  UHDCampusRegionRenderer.h
//  uni-hd
//
//  Created by Andreas Schachner on 03.09.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "UHDCampusRegion.h"

@interface UHDCampusRegionRenderer : MKOverlayRenderer

@property (nonatomic, readonly) UHDCampusRegion *overlay;

- (id)initWithOverlay:(UHDCampusRegion *)overlay;

@end
