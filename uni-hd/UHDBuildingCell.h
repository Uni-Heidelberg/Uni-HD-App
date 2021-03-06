//
//  UHDMapsSearchCell.h
//  uni-hd
//
//  Created by Andreas Schachner on 13.08.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UHDBuilding.h"

@interface UHDBuildingCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *buildingsImageView;
@property (weak, nonatomic) IBOutlet UILabel *campusRegionLabel;

- (void)configureForBuilding:(UHDBuilding *)item;

@end
