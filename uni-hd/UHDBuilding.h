//
//  UHDBuilding.h
//  uni-hd
//
//  Created by Andreas Schachner on 07.08.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDRemoteManagedLocation.h"

@class UHDCampusRegion;

@interface UHDBuilding : UHDRemoteManagedLocation

@property (nonatomic, retain) UHDCampusRegion *campusRegion;
@property (nonatomic, retain) NSString *buildingNumber;
@property (nonatomic, retain) NSData *imageData;

// Computed Properties
@property (readonly) NSString *identifier; // calculated by combining the region's identifier and the building number
@property (nonatomic) UIImage *image;

@end
