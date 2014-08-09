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
    self.distanceLabel.text = [NSString stringWithFormat:@"Dies ist ein Test"];
}

@end
