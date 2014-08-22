//
//  UHDMealCell.h
//  uni-hd
//
//  Created by Felix on 20.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UHDMeal.h"
#import "UHDFavouriteCell.h"

@interface UHDMealCell:UHDFavouriteCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIView *favouriteBar;


@property (nonatomic, strong) UHDMeal *meal;


@end
