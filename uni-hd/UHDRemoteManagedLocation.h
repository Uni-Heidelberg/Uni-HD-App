//
//  UHDLocation.h
//  uni-hd
//
//  Created by Nils Fischer on 08.08.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

@import UHDRemoteKit;
@import MapKit;

MKMapRect MKMapRectForCoordinateRegion(MKCoordinateRegion region);

@interface UHDRemoteManagedLocation : UHDRemoteManagedObject <MKAnnotation>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, retain) CLLocation *location;
@property (nonatomic, retain) NSSet *events;
@property (nonatomic) CLLocationDistance currentDistance;

@end
