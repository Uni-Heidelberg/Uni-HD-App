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
@property (weak, nonatomic) IBOutlet UIImageView *mensaImageView;

@end


@implementation UHDMensaCell

-(void)configureForMensa:(UHDMensa *)mensa
{
    self.mensaLabel.text = mensa.title;
    self.mensaImageView.image = mensa.image;
    if (mensa.currentDistance >= 0) {
        MKDistanceFormatter *distanceFormatter = [[MKDistanceFormatter alloc] init];
        self.distanceLabel.text = [distanceFormatter stringFromDistance:mensa.currentDistance];
    } else {
        self.distanceLabel.text = NSLocalizedString(@"Distance unavailable", nil);
    }

    self.isFavourite = mensa.isFavourite;
}

@end
