//
//  UHDMealCell.h
//  uni-hd
//
//  Created by Felix on 20.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMSwipeTableViewCell.h"
#import "UHDMeal.h"

@interface UHDMealCell : RMSwipeTableViewCell 
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIView *favouriteBar;

@property (nonatomic, strong) UIImageView *checkmarkGreyImageView;
@property (nonatomic, strong) UIImageView *checkmarkGreenImageView;
@property (nonatomic, strong) UHDMeal *meal;

-(void)setFavourite:(BOOL)favourite animated:(BOOL)animated;

@end
