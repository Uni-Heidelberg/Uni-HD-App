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
@dynamic location;


#pragma mark - MKAnnotation Protocol

- (CLLocationCoordinate2D)coordinate
{
    return self.location.coordinate;
}

@end
