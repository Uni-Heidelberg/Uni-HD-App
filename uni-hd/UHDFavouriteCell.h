//
//  UHDFavouriteCell.h
//  uni-hd
//
//  Created by Felix on 09.08.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "RMSwipeTableViewCell.h"

@interface UHDFavouriteCell : RMSwipeTableViewCell

-(void)setFavourite:(BOOL)favourite animated:(BOOL)animated;

@property (nonatomic, assign) Boolean isFavourite;
@end
