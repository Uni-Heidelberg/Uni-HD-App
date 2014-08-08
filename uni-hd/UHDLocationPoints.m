//
//  UHDLocationPoints.m
//  uni-hd
//
//  Created by Andreas Schachner on 07.08.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDLocationPoints.h"

@implementation UHDLocationPoints

@dynamic latitude;
@dynamic longitude;
@dynamic building;

-(void)setCoordinate:(CLLocationCoordinate2D)coordinate
{
    self.latitude = coordinate.latitude;
    self.longitude = coordinate.longitude;
}

-(CLLocationCoordinate2D)coordinate
{
    return CLLocationCoordinate2DMake(self.latitude, self.longitude);
}

@end
