//
//  UHDLocation.m
//  uni-hd
//
//  Created by Nils Fischer on 08.08.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDRemoteManagedLocation.h"

@implementation UHDRemoteManagedLocation

@dynamic title;
@dynamic subtitle;
@synthesize imageName;
@dynamic latitude, longitude;

- (CLLocationCoordinate2D)coordinate
{
    return CLLocationCoordinate2DMake(self.latitude, self.longitude);
}

@end
