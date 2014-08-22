//
//  UHDBuilding.h
//  uni-hd
//
//  Created by Andreas Schachner on 07.08.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDRemoteManagedLocation.h"

//@class UHDBuildingsCategory;
@class UHDRemoteManagedLocation;

@interface UHDBuilding : UHDRemoteManagedLocation

//@property (nonatomic) NSString *title;
//@property (nonatomic, retain) UIImage *image;
//@property (nonatomic, retain) UHDBuildingsCategory *category;
@property (nonatomic) UHDRemoteManagedLocation *location;

@end
