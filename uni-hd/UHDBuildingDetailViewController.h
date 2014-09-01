//
//  UHDBuildingDetailViewController.h
//  uni-hd
//
//  Created by Andreas Schachner on 01.09.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UHDBuilding.h"
#import "UHDLocationCategory.h"


@interface UHDBuildingDetailViewController : UIViewController

@property (strong, nonatomic) UHDBuilding *building;
@property (strong,nonatomic) UHDLocationCategory *category;

@property (strong, nonatomic) IBOutlet UIImageView *buildingsImageView;
@property (strong, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *buildingCategoryLabel;

@end
