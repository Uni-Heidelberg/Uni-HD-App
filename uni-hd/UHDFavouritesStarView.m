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


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextClearRect(ctx, rect);
    
    
    int k;
    
    double r, theta;
    
    
    
    r = MIN(rect.size.height/2, rect.size.width/2)*self.scaleFactor;
    
    theta = 2 * M_PI * (2.0 / 5.0); // 144 degrees
    
    CGContextBeginPath(ctx);
    
    CGContextMoveToPoint(ctx, CGRectGetMidX(rect), CGRectGetMidY(rect)-r);
    
    for (k = 1; k < 5; k++) {
        
        CGContextAddLineToPoint (ctx,
                                 
                                CGRectGetMidX(rect) + r * sin(k * theta),
                                 
                                CGRectGetMidY(rect) - r * cos(k * theta));
        
    }
    
    CGContextClosePath(ctx);
    CGContextSetFillColorWithColor(ctx, self.colour);
    CGContextFillPath(ctx);
}


@end
