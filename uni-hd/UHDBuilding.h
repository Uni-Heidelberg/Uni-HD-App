//
//  UHDBuilding.h
//  uni-hd
//
//  Created by Andreas Schachner on 07.08.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDRemoteManagedLocation.h"

@class UHDLocationCategory, UHDCampusRegion;

@interface UHDBuilding : UHDRemoteManagedLocation

@property (nonatomic, retain) UHDLocationCategory *category;
@property (nonatomic, retain) UHDCampusRegion *campusRegion;
@property (nonatomic, retain) NSDictionary *addressDictionary;
@property (nonatomic, retain) NSString *buildingNumber;
@property (nonatomic, retain) NSData *imageData;

// Computed Properties
@property (readonly) NSString *campusIdentifier; // calculated by combining the campus region's identifier and the building number
@property (nonatomic) UIImage *image;

@end
