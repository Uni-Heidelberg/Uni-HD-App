//
//  UHDLocation.h
//  uni-hd
//
//  Created by Felix on 14.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UHDMensa;

@interface UHDLocation : NSManagedObject

@property (nonatomic) double_t latitude;
@property (nonatomic) double_t longitude;
@property (nonatomic, retain) UHDMensa *mensa;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@end
