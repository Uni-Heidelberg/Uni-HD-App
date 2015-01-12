//
//  UHDBuilding.h
//  uni-hd
//
//  Created by Andreas Schachner on 07.08.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDRemoteManagedLocation.h"

@class UHDLocationCategory, UHDCampusRegion, UHDAddress;
@class Hours;

@interface UHDBuilding : UHDRemoteManagedLocation <MKOverlay>

@property (nonatomic, retain) UHDLocationCategory *category;
@property (nonatomic, retain) UHDCampusRegion *campusRegion;
@property (nonatomic, retain) NSString *buildingNumber;
@property (nonatomic, retain) NSData *imageData;
@property (nonatomic, retain) NSURL *imageURL;
@property (nonatomic) double_t spanLatitude;
@property (nonatomic) double_t spanLongitude;
@property (nonatomic, retain) UHDAddress *address;
@property (nonatomic, retain) NSString *telephone;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSURL *url;
@property (nonatomic, retain) NSSet *associatedNewsSources;
@property (nonatomic, retain) NSSet *associatedNewsSourceIds;
@property (nonatomic, readonly) Hours *hours; // TODO: not yet implemented properly
@property (nonatomic, retain) NSSet *keywords;

// Computed Properties
@property (readonly) NSString *campusIdentifier; // calculated by combining the campus region's identifier and the building number
@property (nonatomic) UIImage *image; // TODO: make readonly and transient as soon as sample data is not necessary anymore
@property (nonatomic) MKCoordinateRegion coordinateRegion;
@property (nonatomic, readonly) MKMapItem *mapItem;
@property (nonatomic, readonly) NSArray *upcomingEvents;

// Mutable To-Many Accessors
- (NSMutableSet *)mutableAssociatedNewsSources;

@end
