//
//  UHDTriangleStatusImageView.m
//  uni-hd
//
//  Created by Lukas Schmidt on 28.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDTriangleStatusImageView.h"

@implementation UHDTriangleStatusImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    CGContextBeginPath(ctx);
    CGContextMoveToPoint   (ctx, CGRectGetMaxX(rect), CGRectGetMinY(rect));  // top right
    CGContextAddLineToPoint(ctx, CGRectGetMinX(rect), CGRectGetMinY(rect));  // top left
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMidY(rect));  // midlle right
    CGContextClosePath(ctx);
    
    CGContextSetFillColorWithColor(ctx, [UIColor favouriteColor].CGColor);
    CGContextFillPath(ctx);
}

@end
