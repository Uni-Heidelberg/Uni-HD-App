//
//  UHDReadIndicatorView.m
//  uni-hd
//
//  Created by Kevin Geier on 07.10.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDReadIndicatorView.h"

IB_DESIGNABLE
@implementation UHDReadIndicatorView

- (CGSize)intrinsicContentSize {
    return CGSizeMake(12, 12);
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat circleSize = MIN(rect.size.width, rect.size.height);
    CGRect circleRect = CGRectMake(rect.size.width/2 - circleSize/2, rect.size.height/2 - circleSize/2, circleSize, circleSize);
    [self.tintColor setFill];
    CGContextFillEllipseInRect(context, circleRect);
}

@end