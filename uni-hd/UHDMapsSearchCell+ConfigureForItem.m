//
//  UHDMapsSearchCell+ConfigureForItem.m
//  uni-hd
//
//  Created by Andreas Schachner on 13.08.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDMapsSearchCell+ConfigureForItem.h"

@implementation UHDMapsSearchCell (ConfigureForItem)

- (void)configureForItem:(UHDBuilding *)item {
    
    // Configure text
    self.titleLabel.text = item.title;

    // Configure Image
    //UIImage *image = item.image;
    //self.buildingsImageView.image = image;
    
}



@end
