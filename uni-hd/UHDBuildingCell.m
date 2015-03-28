//
//  UHDMapsSearchCell.m
//  uni-hd
//
//  Created by Andreas Schachner on 13.08.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDBuildingCell.h"
#import <UHDKit/UHDKit-Swift.h>


@implementation UHDBuildingCell

- (void)configureForInstitution:(Institution *)item {
    
    // Configure text
    self.titleLabel.text = item.title;
    self.subtitleLabel.text = item.location.campusIdentifier;
    
    // Configure Image
    self.buildingsImageView.image = item.location.image;
    
}

@end
