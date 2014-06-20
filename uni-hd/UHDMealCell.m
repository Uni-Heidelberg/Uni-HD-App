//
//  UHDMealCell.m
//  uni-hd
//
//  Created by Felix on 20.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDMealCell.h"


@interface UHDMealCell () 
@end

@implementation UHDMealCell

-(void)awakeFromNib {
    [super awakeFromNib];
}

-(UIImageView*)checkmarkGreyImageView {
    if (!_checkmarkGreyImageView) {
        _checkmarkGreyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.contentView.frame), 0, CGRectGetHeight(self.frame), CGRectGetHeight(self.frame))];
        [_checkmarkGreyImageView setImage:[UIImage imageNamed:@"CheckmarkGrey"]];
        [_checkmarkGreyImageView setContentMode:UIViewContentModeCenter];
        [self.backView addSubview:_checkmarkGreyImageView];
    }
    return _checkmarkGreyImageView;
}

-(UIImageView*)checkmarkGreenImageView {
    if (!_checkmarkGreenImageView) {
        _checkmarkGreenImageView = [[UIImageView alloc] initWithFrame:self.checkmarkGreyImageView.bounds];
        [_checkmarkGreenImageView setImage:[UIImage imageNamed:@"CheckmarkGreen"]];
        [_checkmarkGreenImageView setContentMode:UIViewContentModeCenter];
        [self.checkmarkGreyImageView addSubview:_checkmarkGreenImageView];
    }
    return _checkmarkGreenImageView;
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
        // set the checkmark's frame to match the contentView
        [self.checkmarkGreyImageView setFrame:CGRectMake(MAX(CGRectGetMaxX(self.frame) - CGRectGetWidth(self.checkmarkGreyImageView.frame), CGRectGetMaxX(self.contentView.frame)), CGRectGetMinY(self.checkmarkGreyImageView.frame), CGRectGetWidth(self.checkmarkGreyImageView.frame), CGRectGetHeight(self.checkmarkGreyImageView.frame))];
        if (-point.x >= CGRectGetHeight(self.frame) && self.meal.isFavourite == NO) {
            [self.checkmarkGreenImageView setAlpha:1];
        } else if (self.meal.isFavourite == NO) {
            [self.checkmarkGreenImageView setAlpha:0];
        } else if (-point.x >= CGRectGetHeight(self.frame) && self.meal.isFavourite == YES) {
            // already a favourite; animate the green checkmark drop when swiped far enough for the action to kick in when user lets go
                [UIView animateWithDuration:0.25
                                 animations:^{
                                     CATransform3D rotate = CATransform3DMakeRotation(-0.4, 0, 0, 1);
                                     [self.checkmarkGreenImageView.layer setTransform:CATransform3DTranslate(rotate, -10, 20, 0)];
                                     [self.checkmarkGreenImageView setAlpha:0];
                                 }];
            self.favouriteBar.hidden = YES;
        } else if (self.meal.isFavourite == YES) {
            // already a favourite; but user panned back to a lower value than the action point
            CATransform3D rotate = CATransform3DMakeRotation(0, 0, 0, 1);
            [self.checkmarkGreenImageView.layer setTransform:CATransform3DTranslate(rotate, 0, 0, 0)];
            [self.checkmarkGreenImageView setAlpha:1];
            self.favouriteBar.hidden = NO;

        }}
}

-(void)resetCellFromPoint:(CGPoint)point velocity:(CGPoint)velocity {
    [super resetCellFromPoint:point velocity:velocity];
    if (point.x < 0 && -point.x <= CGRectGetHeight(self.frame)) {
        // user did not swipe far enough, animate the checkmark back with the contentView animation
        [UIView animateWithDuration:self.animationDuration
                         animations:^{
                            [self.checkmarkGreyImageView setFrame:CGRectMake(CGRectGetMaxX(self.frame), CGRectGetMinY(self.checkmarkGreyImageView.frame), CGRectGetWidth(self.checkmarkGreyImageView.frame), CGRectGetHeight(self.checkmarkGreyImageView.frame))];
                         }];
    }
}

-(void)cleanupBackView {
    [super cleanupBackView];
    [_checkmarkGreyImageView removeFromSuperview];
    _checkmarkGreyImageView = nil;
    [_checkmarkGreenImageView removeFromSuperview];
    _checkmarkGreenImageView = nil;
}
@end

