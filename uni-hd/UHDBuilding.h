//
//  UHDBuilding.h
//  uni-hd
//
//  Created by Andreas Schachner on 07.08.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDRemoteManagedObject.h"

@class UHDLocationPoints;

@interface UHDBuilding : UHDRemoteManagedObject <MKAnnotation>

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) UHDLocationPoints *location;

-(id) initWithTitle:(NSString *) title AndCoordinate:(CLLocationCoordinate2D)coordinate;

@end
