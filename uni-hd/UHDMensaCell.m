//
//  UHDMensaCell.m
//  uni-hd
//
//  Created by Felix on 09.08.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDMensaCell.h"


@interface UHDMensaCell()

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *mensaLabel;
@property (weak, nonatomic) IBOutlet CircularProgressView *hoursProgressView;

@end


@implementation UHDMensaCell

-(void)configureForMensa:(UHDMensa *)mensa
{
    self.mensaLabel.text = mensa.title;
    [self.hoursProgressView configureForHoursOfMensa:mensa];
    self.distanceLabel.attributedText = mensa.attributedStatusDescription;
    self.isFavourite = mensa.isFavourite;
}

@end
