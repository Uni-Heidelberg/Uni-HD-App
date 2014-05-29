//
//  UHDNewsItemCell.h
//  uni-hd
//
//  Created by Kevin Geier on 14.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UHDNewsItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *abstractLabel;
@property (weak, nonatomic) IBOutlet UIImageView *newsImageView;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIView *readBarView;

// Auto layout constraints for NewsItemCells with image or without image respectively
@property (strong, nonatomic) NSLayoutConstraint *abstractLabelHorizontalSpacingToImageViewConstraint;
@property (strong, nonatomic) NSLayoutConstraint *abstractLabelProportionalWidthToImageViewConstraint;
@property (strong, nonatomic) NSLayoutConstraint *abstractLabelLeadingSpaceToSuperviewConstraint;

- (void)updateLabelPreferredMaxLayoutWidthToCurrentWidth;

@end
