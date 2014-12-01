//
//  UHDBuilding.h
//  uni-hd
//
//  Created by Andreas Schachner on 07.08.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDRemoteManagedLocation.h"

@class UHDLocationCategory, UHDCampusRegion;

@interface UHDBuilding : UHDRemoteManagedLocation <MKOverlay>

@property (nonatomic, retain) UHDLocationCategory *category;
@property (nonatomic, retain) UHDCampusRegion *campusRegion;
@property (nonatomic, retain) NSDictionary *addressDictionary;
@property (nonatomic, retain) NSString *buildingNumber;
@property (nonatomic, retain) NSData *imageData;
@property (nonatomic) double_t spanLatitude;
@property (nonatomic) double_t spanLongitude;

// Computed Properties
@property (readonly) NSString *campusIdentifier; // calculated by combining the campus region's identifier and the building number
@property (nonatomic) UIImage *image;
@property (nonatomic) MKCoordinateRegion coordinateRegion;

@end
