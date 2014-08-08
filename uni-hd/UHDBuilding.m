//
//  UHDBuilding.m
//  uni-hd
//
//  Created by Andreas Schachner on 07.08.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDBuilding.h"
#import "UHDLocationPoints.h"

@implementation UHDBuilding

@dynamic location;

@synthesize coordinate=_coordinate;
@synthesize title=_title;

-(id) initWithTitle:(NSString *) title AndCoordinate:(CLLocationCoordinate2D)coordinate
{
    self = [super init];
    _title = title;
    _coordinate = coordinate;
    return self;
}



# pragma mark - MKAnnotation Protocol

//- (CLLocationCoordinate2D)coordinate
//{
  //  return self.location.coordinate;
//}


@end
