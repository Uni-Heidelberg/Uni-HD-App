//
//  UHDMensaCell+ConfigureForItem.m
//  uni-hd
//
//  Created by Felix on 09.08.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDMensaCell+ConfigureForItem.h"

@implementation UHDMensaCell (ConfigureForItem)

-(void)configureForMensa:(UHDMensa *)mensa{
    
    self.mensaLabel.text = mensa.title;
    self.mensaImageView.image = self.mensa.image;
    self.distanceLabel.text = [[NSString alloc]
                               initWithFormat:@"%0.1f km",
                               self.mensa.currentDistanceInKm];
}

@end
