//
//  UHDMealCell.h
//  uni-hd
//
//  Created by Felix on 20.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UHDFavouriteCell.h"
#import "UHDMeal.h"

@interface UHDMealCell : UHDFavouriteCell

- (void)configureForMeal:(UHDMeal *)meal;

@end
