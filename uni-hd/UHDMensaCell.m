//
//  UHDMensaCell.m
//  uni-hd
//
//  Created by Felix on 09.08.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDMensaCell.h"

@implementation UHDMensaCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)setIsFavourite:(Boolean)isFavourite {
    self.mensa.isFavourite = isFavourite;
}
- (Boolean)isFavourite {
    return self.mensa.isFavourite;
}


-(void)calculateDistanceWith:(CLLocation *)currentLocation
{
    CLLocation *mensaLocation = [[CLLocation alloc]initWithLatitude:self.mensa.latitude longitude:self.mensa.longitude];
                                 
    CLLocationDistance distanceBetween = [currentLocation
                                          distanceFromLocation:mensaLocation];
    float distanceInKilometers = distanceBetween/1000;
  self.distanceLabel.text = [[NSString alloc]
                            initWithFormat:@"%0.1f km",
                            distanceInKilometers];
}
@end
