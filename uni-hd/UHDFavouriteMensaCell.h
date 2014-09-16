//
//  UHDFavouriteMensaCell.h
//  uni-hd
//
//  Created by Felix on 16.09.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UHDMensa.h"

@interface UHDFavouriteMensaCell : UITableViewCell

- (void)addFavouriteMensa:(UHDMensa *)mensa;
-(void)removeFavouriteMensa:(UHDMensa *)mensa;
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIImageView *image3;

@end
