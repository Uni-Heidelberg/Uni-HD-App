//
//  UHDMensaCell.h
//  uni-hd
//
//  Created by Felix on 09.08.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDFavouriteCell.h"
@class Mensa;

@interface UHDMensaCell : UHDFavouriteCell 

- (void)configureForMensa:(Mensa *)mensa;

@end
