//
//  UHDCampusRegion.h
//  uni-hd
//
//  Created by Andreas Schachner on 27.08.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDRemoteManagedObject.h"

@class UHDCampusRegionRenderer;

@interface UHDCampusRegion : UHDRemoteManagedObject <MKOverlay>

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *identifier;
@property (nonatomic, retain) NSSet *buildings;
@property (nonatomic, retain) UHDCampusRegionRenderer *render;
@property (nonatomic) double_t overlayTopLeftCoordinateLat;
@property (nonatomic) double_t overlayTopLeftCoordinateLong;
@property (nonatomic) double_t overlayTopRightCoordinateLat;
@property (nonatomic) double_t overlayTopRightCoordinateLong;
@property (nonatomic) double_t overlayBottomLeftCoordinateLat;
@property (nonatomic) double_t overlayBottomLeftCoordinateLong;
@property (nonatomic) double_t overlayBottomRightCoordinateLat;
@property (nonatomic) double_t overlayBottomRightCoordinateLong;
@property (nonatomic) double_t latitude;
@property (nonatomic) double_t longitude;


- (NSMutableSet *)mutableBuildings;
- (MKMapRect)overlayBoundingMapRect;
- (instancetype)initWithRegion:(UHDCampusRegion *)campusRegion;

@end
