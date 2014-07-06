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
@property (nonatomic, strong) UHDFavouritesStarView *greyStarUIView;
@property (nonatomic, strong) UHDFavouritesStarView *yellowStarUIView;
@end

@implementation UHDMealCell

-(void)awakeFromNib {
    [super awakeFromNib];
}


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
        _yellowStarUIView.colour = [[UIColor yellowColor]CGColor];
        [self.greyStarUIView addSubview:_yellowStarUIView];
    }
    return _yellowStarUIView;
}

-(void)setFavourite:(BOOL)favourite animated:(BOOL)animated {
    self.meal.isFavourite = favourite;
    
//    if (animated) {
//        if (favourite) {
//            NSLog(@"Es ist als favorite & animated markiert");
//            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"borderColor"];
//            animation.toValue = (id)[UIColor colorWithRed:0.149 green:0.784 blue:0.424 alpha:0.750].CGColor;
//            animation.fromValue = (id)[UIColor colorWithWhite:0 alpha:0.3].CGColor;
//            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//            animation.duration = 0.25;
//            [self.profileImageView.layer addAnimation:animation forKey:@"animateBorderColor"];
//            [self.profileImageView.layer setBorderColor:[UIColor colorWithRed:0.149 green:0.784 blue:0.424 alpha:0.750].CGColor];
//            [self.checkmarkProfileImageView setAlpha:0];
//            [self.profileImageView addSubview:_checkmarkProfileImageView];
//            [UIView animateWithDuration:0.25
//                             animations:^{
//                                 [self.checkmarkProfileImageView setAlpha:1];
//                             }];
//        } else {
//             NSLog(@"Es ist als animated & nicht als favourite markiert");
//            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"borderColor"];
//            animation.toValue = (id)[UIColor colorWithWhite:0 alpha:0.3].CGColor;
//            animation.fromValue = (id)[UIColor colorWithRed:0.149 green:0.784 blue:0.424 alpha:0.750].CGColor;
//            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//            animation.duration = 0.25;
//            [self.profileImageView.layer addAnimation:animation forKey:@"animateBorderColor"];
//            [self.profileImageView.layer setBorderColor:[UIColor colorWithWhite:0 alpha:0.3].CGColor];
//            [UIView animateWithDuration:0.25
//                             animations:^{
//                                 [self.checkmarkProfileImageView setAlpha:0];
//                             }
//                             completion:^(BOOL finished) {
//                                 [_checkmarkProfileImageView removeFromSuperview];
//                             }];
//        }
//    } else {
//        if (favourite) {
//            [self.checkmarkProfileImageView setAlpha:1];
//            [self.profileImageView addSubview:_checkmarkProfileImageView];
//            [self.profileImageView.layer setBorderColor:[UIColor colorWithRed:0.149 green:0.784 blue:0.424 alpha:0.750].CGColor];
//        } else {
//            [self.checkmarkProfileImageView setAlpha:0];
//            [_checkmarkProfileImageView removeFromSuperview];
//            [self.profileImageView.layer setBorderColor:[UIColor colorWithWhite:0 alpha:0.3].CGColor];
//        }
//    }
}

-(void)animateContentViewForPoint:(CGPoint)point velocity:(CGPoint)velocity {
    if (point.x > 0) {
        return;
    }
    if (point.x < 0) {
        [super animateContentViewForPoint:point velocity:velocity];
        // set the star's frame to match the contentView
        [self.greyStarUIView setFrame:CGRectMake(MAX(CGRectGetMaxX(self.frame) - CGRectGetWidth(self.greyStarUIView.frame), CGRectGetMaxX(self.contentView.frame)), CGRectGetMinY(self.greyStarUIView.frame), CGRectGetWidth(self.greyStarUIView.frame), CGRectGetHeight(self.greyStarUIView.frame))];
        if (-point.x >= CGRectGetHeight(self.frame) && self.meal.isFavourite == NO) {
            self.yellowStarUIView.scaleFactor = 1;
        } else if (self.meal.isFavourite == NO) {
            self.yellowStarUIView.scaleFactor = -point.x/CGRectGetHeight(self.frame);
        } else if (-point.x >= CGRectGetHeight(self.frame) && self.meal.isFavourite == YES) {
            // already a favourite; animate the green checkmark drop when swiped far enough for the action to kick in when user lets go
            self.yellowStarUIView.scaleFactor = 0;
            self.favouriteBar.hidden = YES;
        } else if (self.meal.isFavourite == YES) {
            // already a favourite; but user panned back to a lower value than the action point
            self.yellowStarUIView.scaleFactor = 1 + point.x/CGRectGetHeight(self.frame);
            self.favouriteBar.hidden = NO;

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

