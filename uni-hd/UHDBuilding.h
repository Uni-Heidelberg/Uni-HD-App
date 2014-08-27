//
//  UHDBuilding.h
//  uni-hd
//
//  Created by Andreas Schachner on 07.08.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDRemoteManagedLocation.h"

@class UHDRemoteManagedLocation;
@class UHDLocationCategory;
@class UHDCampusRegion;

@interface UHDBuilding : UHDRemoteManagedLocation

//@property (nonatomic) NSString *title;
@property (nonatomic, retain) UHDLocationCategory *category;
@property (nonatomic) UHDRemoteManagedLocation *location;
@property (nonatomic) UHDCampusRegion *campusRegion;
@property (readonly) NSString *buildingIdentifier;

@end
