//
//  UHDLocation.h
//  uni-hd
//
//  Created by Nils Fischer on 08.08.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDRemoteManagedObject.h"


MKMapRect MKMapRectForCoordinateRegion(MKCoordinateRegion region);

@interface UHDRemoteManagedLocation : UHDRemoteManagedObject <MKAnnotation>

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) CLLocation *location;
@property (nonatomic) CLLocationDistance currentDistance;

@end
