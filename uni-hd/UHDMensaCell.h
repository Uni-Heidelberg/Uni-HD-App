//
//  UHDMensaCell.h
//  uni-hd
//
//  Created by Felix on 09.08.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDFavouriteCell.h"
#import "UHDMensa.h"
#import "UHDSelectMensaDelegateProtocol.h"



@interface UHDMensaCell : UHDFavouriteCell 

@property (nonatomic, strong) UHDMensa *mensa;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *mensaLabel;
- (void)calculateDistanceWith:(CLLocation *)currentLocation;
@end
