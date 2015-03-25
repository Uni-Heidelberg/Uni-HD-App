//
//  UHDFavouriteCell.m
//  uni-hd
//
//  Created by Felix on 09.08.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDFavouriteCell.h"
#import "UHDFavouritesStarView.h"
#import "UIColor+UHDColors.h"

#define kUHDFavouriteCellStarSize 44
#define kUHDFavouriteCellStarOffset 10
#define kUHDFavouriteCellTriggerLength 30

@interface UHDFavouriteCell ()

@property (strong, nonatomic) UHDFavouritesStarView *backgroundStarUIView;
@property (strong, nonatomic) UHDFavouritesStarView *favouriteStarUIView;

@end

@implementation UHDFavouriteCell

- (UHDFavouritesStarView *)backgroundStarUIView {
    if (!_backgroundStarUIView) {
        _backgroundStarUIView = [[UHDFavouritesStarView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.contentView.frame), CGRectGetMidY(self.backView.frame) - kUHDFavouriteCellStarSize / 2, kUHDFavouriteCellStarSize + 2 * kUHDFavouriteCellStarOffset, kUHDFavouriteCellStarSize)];
        _backgroundStarUIView.color = [UIColor whiteColor];
        _backgroundStarUIView.scaleFactor = 1.0;
        [self.backView addSubview:_backgroundStarUIView];
    }
    return _backgroundStarUIView;
}

- (UHDFavouritesStarView*)favouriteStarUIView {
    if (!_favouriteStarUIView) {
        _favouriteStarUIView = [[UHDFavouritesStarView alloc] initWithFrame:self.backgroundStarUIView.bounds];
        _favouriteStarUIView.color = [UIColor favouriteColor];
        [self.backgroundStarUIView addSubview:_favouriteStarUIView];
    }
    return _favouriteStarUIView;
}

- (UIView *)backView {
    UIView *backView = [super backView];
    backView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return backView;
}

-(void)animateContentViewForPoint:(CGPoint)point velocity:(CGPoint)velocity {
    if (point.x < 0) {
        [super animateContentViewForPoint:point velocity:velocity];
        
        [self.backgroundStarUIView setFrame:CGRectMake(MAX(CGRectGetMaxX(self.frame) - self.backgroundStarUIView.frame.size.width, CGRectGetMaxX(self.contentView.frame)), self.backgroundStarUIView.frame.origin.y, self.backgroundStarUIView.frame.size.width, self.backgroundStarUIView.frame.size.height)];
        
        CGFloat panLength = -point.x - self.backgroundStarUIView.frame.size.width;
        CGFloat scaleFactor = MAX(MIN(panLength / kUHDFavouriteCellTriggerLength, 1), 0);
        if (self.isFavourite) {
            scaleFactor = 1 - scaleFactor;
        }
        self.favouriteStarUIView.scaleFactor = scaleFactor;
        [self.favouriteStarUIView setNeedsDisplay];
    }
}

- (BOOL)shouldTriggerForPoint:(CGPoint)point
{
    return -point.x - self.backgroundStarUIView.frame.size.width >= kUHDFavouriteCellTriggerLength;
}

-(void)cleanupBackView {
    [super cleanupBackView];
    [self.backgroundStarUIView removeFromSuperview];
    self.backgroundStarUIView = nil;
    [self.favouriteStarUIView removeFromSuperview];
    self.favouriteStarUIView = nil;
}

@end
