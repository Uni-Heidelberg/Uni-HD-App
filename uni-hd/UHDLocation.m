//
//  UHDLocation.m
//  uni-hd
//
//  Created by Felix on 14.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDLocation.h"
#import "UHDMensa.h"


@implementation UHDLocation

@dynamic latitude;
@dynamic longitude;
@dynamic mensa;

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
