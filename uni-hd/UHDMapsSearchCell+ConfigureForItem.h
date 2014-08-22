//
//  UHDMapsSearchCell+ConfigureForItem.h
//  uni-hd
//
//  Created by Andreas Schachner on 13.08.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDMapsSearchCell.h"
#import "UHDBuilding.h"

@interface UHDMapsSearchCell (ConfigureForItem)

- (void)configureForItem:(UHDBuilding *)item;

@end
