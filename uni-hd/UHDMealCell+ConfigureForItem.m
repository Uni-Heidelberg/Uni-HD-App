//
//  UHDMealCell+ConfigureForItem.m
//  uni-hd
//
//  Created by Felix on 21.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDMealCell+ConfigureForItem.h"

@implementation UHDMealCell (ConfigureForItem)

- (void)configureForMeal:(UHDMeal *)meal
{
    self.titleLabel.text = meal.title;
    self.priceLabel.text = meal.price;
    self.favouriteBar.hidden = !meal.isFavourite;
}

@end
