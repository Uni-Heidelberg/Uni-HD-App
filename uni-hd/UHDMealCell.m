//
//  UHDMealCell.m
//  uni-hd
//
//  Created by Felix on 20.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDMealCell.h"
#import "UHDFavouritesStarView.h"


@interface UHDMealCell ()
@end

@implementation UHDMealCell

- (void)setIsFavourite:(Boolean)isFavourite {
    self.meal.isFavourite = isFavourite;
}
- (Boolean)isFavourite {
    return self.meal.isFavourite;
}

@end

