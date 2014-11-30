//
//  UHDCampusRegion.h
//  uni-hd
//
//  Created by Andreas Schachner on 27.08.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDRemoteManagedLocation.h"
#import "VIImageOverlayRenderer.h"

@interface UHDCampusRegion : UHDRemoteManagedLocation <MKOverlay>

@property (nonatomic, retain) NSString *identifier;
@property (nonatomic, retain) NSSet *buildings;
@property (nonatomic) double_t spanLatitude;
@property (nonatomic) double_t spanLongitude;

// Computed Properties
- (MKCoordinateRegion)coordinateRegion;

// Mutable To-Many Accessors
- (NSMutableSet *)mutableBuildings;

@end
