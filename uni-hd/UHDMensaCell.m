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
@property (weak, nonatomic) IBOutlet CircularProgressView *hoursProgressView;
@property (weak, nonatomic) IBOutlet UIImageView *favouriteSymbolView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *favouriteSymbolSpacingConstraint;
@property (strong, nonatomic) NSLayoutConstraint *favouriteSymbolHiddenConstraint;

@end


@implementation UHDMensaCell

- (void)awakeFromNib{
    [super awakeFromNib];
    self.favouriteSymbolView.tintColor = [UIColor favouriteColor];
}

-(void)configureForMensa:(UHDMensa *)mensa
{
    self.mensaLabel.text = mensa.title;
    [self.hoursProgressView configureForHoursOfMensa:mensa];
    self.distanceLabel.attributedText = mensa.attributedStatusDescription;
    self.isFavourite = mensa.isFavourite;
    self.favouriteSymbolView.hidden = !mensa.isFavourite;
    [self.favouriteSymbolView.superview removeConstraint: self.isFavourite ? self.favouriteSymbolHiddenConstraint : self.favouriteSymbolSpacingConstraint];
    [self.favouriteSymbolView.superview addConstraint: self.isFavourite ? self.favouriteSymbolSpacingConstraint : self.favouriteSymbolHiddenConstraint];
}

- (NSLayoutConstraint *)favouriteSymbolHiddenConstraint {
    if (!_favouriteSymbolHiddenConstraint) {
        self.favouriteSymbolHiddenConstraint = [NSLayoutConstraint constraintWithItem:self.distanceLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.distanceLabel.superview attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    }
    return _favouriteSymbolHiddenConstraint;
}

@end
