//
//  UHDMensaDetailViewController.m
//  uni-hd
//
//  Created by Felix on 25.06.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDMensaDetailViewController.h"

@implementation UHDMensaDetailViewController

- (void)setMensa:(UHDMensa *)mensa
{
    self.building = mensa;
}

- (UHDMensa *)mensa
{
    return (UHDMensa *)self.building;
}


@end
