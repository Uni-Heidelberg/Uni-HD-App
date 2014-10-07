//
//  UHDNewsItemCell.h
//  uni-hd
//
//  Created by Kevin Geier on 14.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UHDReadIndicatorView.h"

@interface UHDNewsItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *abstractLabel;
@property (weak, nonatomic) IBOutlet UIImageView *newsImageView;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIView *readIndicatorContainerView;
@property (weak, nonatomic) IBOutlet UHDReadIndicatorView *readIndicatorView;



// Auto layout constraints for NewsItemCells with or without image respectively
@property (strong, nonatomic) NSArray *layoutContraintsWithImage;
@property (strong, nonatomic) NSArray *layoutContraintsWithoutImage;

@end
