//
//  UHDMensaCell.m
//  uni-hd
//
//  Created by Felix on 09.08.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDMensaCell.h"

@interface UHDMensaCell()
@end

@implementation UHDMensaCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
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
    CLLocation *mensaLocation = self.mensa.location;
                                 
    CLLocationDistance distanceBetween = [currentLocation
                                          distanceFromLocation:mensaLocation];
    self.mensa.currentDistanceInKm = distanceBetween/1000;

    //NSLog(@"the current Distance for Mensa %@ is %f", self.mensa.title, self.mensa.currentDistanceInKm);
}
@end
