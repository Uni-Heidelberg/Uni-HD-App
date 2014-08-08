//
//  UHDLocationPoints.h
//  uni-hd
//
//  Created by Andreas Schachner on 07.08.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "UHDBuilding.h"

@interface UHDLocationPoints : NSManagedObject

@property (nonatomic) double_t latitude;
@property (nonatomic) double_t longitude;
@property (nonatomic, retain) UHDBuilding *building;
@property (nonatomic) CLLocationCoordinate2D coordinate;

@end
