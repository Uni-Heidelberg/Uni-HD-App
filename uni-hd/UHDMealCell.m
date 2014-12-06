//
//  UHDMealCell.m
//  uni-hd
//
//  Created by Felix on 20.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDMealCell.h"


@interface UHDMealCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *favouriteSign;

@end


@implementation UHDMealCell

- (void)configureForMeal:(UHDMeal *)meal
{
    self.titleLabel.text = meal.title;
    self.priceLabel.text = meal.price;
    self.isFavourite = meal.isFavourite;
    self.favouriteSign.hidden = !meal.isFavourite;
}

@end

