//
//  UHDReadIndicatorView.m
//  uni-hd
//
//  Created by Kevin Geier on 07.10.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDReadIndicatorView.h"

@implementation UHDReadIndicatorView

/*
- (id)initWithFrame:(CGRect)inFrame {
    self = [super initWithFrame:inFrame];
    if(self != nil) {
        // initialize
    }
    return self;
}
*/

- (void)drawRect:(CGRect)inRectangle {
    CGContextRef theContext = UIGraphicsGetCurrentContext();
    CGRect theBounds = self.bounds;
    CGContextSaveGState(theContext);
	CGContextSetFillColorWithColor(theContext, [[UIColor brandColor] CGColor]);
    CGContextAddEllipseInRect(theContext, theBounds);
    CGContextFillPath(theContext);
    CGContextRestoreGState(theContext);
}

@end