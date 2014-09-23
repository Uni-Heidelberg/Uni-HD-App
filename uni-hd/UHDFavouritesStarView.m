//
//  UHDFavouritesStarView.m
//  uni-hd
//
//  Created by Felix on 06.07.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDFavouritesStarView.h"

@implementation UHDFavouritesStarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGFloat r = MIN(rect.size.height, rect.size.width) / 2 * self.scaleFactor;
    CGFloat theta = 2 * M_PI * (2.0 / 5.0); // 144 degrees

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, CGRectGetMidX(rect), CGRectGetMidY(rect)-r);
    
    for (int k = 1; k < 5; k++) {
        CGContextAddLineToPoint(context, CGRectGetMidX(rect) + r * sin(k * theta), CGRectGetMidY(rect) - r * cos(k * theta));
    }
    
    CGContextClosePath(context);
    [self.color setFill];
    CGContextFillPath(context);
}


@end
