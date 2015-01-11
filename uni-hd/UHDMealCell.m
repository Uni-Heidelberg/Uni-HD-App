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
@property (weak, nonatomic) IBOutlet UILabel *extrasLabel;
@property (weak, nonatomic) IBOutlet UIImageView *favouriteSymbolView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *favouriteSymbolSpacingConstraint;
@property (strong, nonatomic) NSLayoutConstraint *favouriteSymbolHiddenConstraint;

@end


@implementation UHDMealCell

- (void)configureForMeal:(UHDMeal *)meal
{
    UIFontDescriptor *fontDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleBody];
    if (meal.isMain) {
        fontDescriptor = [fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
    }
    self.titleLabel.font = [UIFont fontWithDescriptor:fontDescriptor size:0];
    self.titleLabel.text = meal.title;
    self.priceLabel.text = meal.localizedPriceDescription;
    self.extrasLabel.text = meal.localizedExtrasDescription;
    //self.isFavourite = meal.isFavourite;
    self.favouriteSymbolView.hidden = !meal.isFavourite;
    [self.favouriteSymbolView.superview removeConstraint: meal.isFavourite ? self.favouriteSymbolHiddenConstraint : self.favouriteSymbolSpacingConstraint];
    [self.favouriteSymbolView.superview addConstraint: meal.isFavourite ? self.favouriteSymbolSpacingConstraint : self.favouriteSymbolHiddenConstraint];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:UHDUserDefaultsKeyVegetarian] && !meal.isVegetarian) {
        self.titleLabel.textColor = [UIColor darkGrayColor];
    }
    else {
        self.titleLabel.textColor = [UIColor blackColor];
    }
    
}

- (NSLayoutConstraint *)favouriteSymbolHiddenConstraint {
    if (!_favouriteSymbolHiddenConstraint) {
        self.favouriteSymbolHiddenConstraint = [NSLayoutConstraint constraintWithItem:self.extrasLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.titleLabel attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    }
    return _favouriteSymbolHiddenConstraint;
}

@end

