//
//  UHDFavouriteCell.m
//  uni-hd
//
//  Created by Felix on 09.08.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDFavouriteCell.h"
#import "UHDFavouritesStarView.h"


@interface UHDFavouriteCell ()

@property (nonatomic, strong) UHDFavouritesStarView *greyStarUIView;
@property (nonatomic, strong) UHDFavouritesStarView *yellowStarUIView;
@end

@implementation UHDFavouriteCell


-(UHDFavouritesStarView*)greyStarUIView {
    if (!_greyStarUIView) {
        _greyStarUIView = [[UHDFavouritesStarView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.contentView.frame), 0, CGRectGetHeight(self.frame), CGRectGetHeight(self.frame))];
        _greyStarUIView.colour = [[UIColor grayColor]CGColor];
        _greyStarUIView.scaleFactor = 1.0;
        [self.backView addSubview:_greyStarUIView];
    }
    return _greyStarUIView;
}

-(UHDFavouritesStarView*)yellowStarUIView {
    if (!_yellowStarUIView) {
        _yellowStarUIView = [[UHDFavouritesStarView alloc] initWithFrame:self.greyStarUIView.bounds];
        _yellowStarUIView.colour = [[UIColor favouriteColor] CGColor];
        [self.greyStarUIView addSubview:_yellowStarUIView];
    }
    return _yellowStarUIView;
}

- (void)setFavourite:(BOOL)favourite animated:(BOOL)animated {
    self.isFavourite = favourite;
}

-(void)animateContentViewForPoint:(CGPoint)point velocity:(CGPoint)velocity {
    if (point.x > 0) {
        return;
    }
    if (point.x < 0) {
        [super animateContentViewForPoint:point velocity:velocity];
        // set the star's frame to match the contentView
        [self.greyStarUIView setFrame:CGRectMake(MAX(CGRectGetMaxX(self.frame) - CGRectGetWidth(self.greyStarUIView.frame), CGRectGetMaxX(self.contentView.frame)), CGRectGetMinY(self.greyStarUIView.frame), CGRectGetWidth(self.greyStarUIView.frame), CGRectGetHeight(self.greyStarUIView.frame))];
        if (-point.x >= CGRectGetHeight(self.frame) && self.isFavourite == NO) {
            self.yellowStarUIView.scaleFactor = 1;
        } else if (self.isFavourite == NO) {
            self.yellowStarUIView.scaleFactor = pow(-point.x/CGRectGetHeight(self.frame), 4);
        } else if (-point.x >= CGRectGetHeight(self.frame) && self.isFavourite == YES) {
            self.yellowStarUIView.scaleFactor = 0;
       //     self.favouriteBar.hidden = YES;
        } else if (self.isFavourite == YES) {
            // already a favourite; but user panned back to a lower value than the action point
            self.yellowStarUIView.scaleFactor = 1 - pow(point.x/CGRectGetHeight(self.frame), 4);
         //   self.favouriteBar.hidden = NO;
            
        }
        [self.yellowStarUIView setNeedsDisplay];
    }
}

-(void)resetCellFromPoint:(CGPoint)point velocity:(CGPoint)velocity {
    [super resetCellFromPoint:point velocity:velocity];
    if (point.x < 0 && -point.x <= CGRectGetHeight(self.frame)) {
        // user did not swipe far enough, animate the checkmark back with the contentView animation
        [UIView animateWithDuration:self.animationDuration
                         animations:^{
                             [self.greyStarUIView setFrame:CGRectMake(CGRectGetMaxX(self.frame), CGRectGetMinY(self.greyStarUIView.frame), CGRectGetWidth(self.greyStarUIView.frame), CGRectGetHeight(self.greyStarUIView.frame))];
                         }];
    }
}

-(void)cleanupBackView {
    [super cleanupBackView];
    [self.greyStarUIView removeFromSuperview];
    self.greyStarUIView = nil;
    [self.yellowStarUIView removeFromSuperview];
    self.yellowStarUIView = nil;
}
@end
