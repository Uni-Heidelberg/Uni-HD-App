//
//  UHDFavouriteCell.h
//  uni-hd
//
//  Created by Felix on 09.08.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

@import RMSwipeTableViewCell;

@interface UHDFavouriteCell : RMSwipeTableViewCell

@property (nonatomic) BOOL isFavourite;

- (BOOL)shouldTriggerForPoint:(CGPoint)point;

@end
