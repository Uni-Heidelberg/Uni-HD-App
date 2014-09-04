//
//  UHDCampusRegion.h
//  uni-hd
//
//  Created by Andreas Schachner on 27.08.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDRemoteManagedObject.h"

@interface UHDCampusRegion : UHDRemoteManagedObject <MKOverlay>

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *identifier;
@property (nonatomic, retain) NSSet *buildings;
@property (nonatomic) double_t centerLatitude;
@property (nonatomic) double_t centerLongitude;
@property (nonatomic) double_t deltaLatitude;
@property (nonatomic) double_t deltaLongitude;

// Computed Properties
- (MKCoordinateRegion)coordinateRegion;

// Mutable To-Many Accessors
- (NSMutableSet *)mutableBuildings;


@end
