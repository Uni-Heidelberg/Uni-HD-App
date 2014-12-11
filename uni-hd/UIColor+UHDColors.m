//
//  UIColor+UHDBrandColor.m
//  uni-hd
//
//  Created by Nils Fischer on 22.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UIColor+UHDColors.h"

@implementation UIColor (UHDColors)

+ (UIColor *)brandColor
{
    return [UIColor colorWithRed:181/255. green:21/255. blue:43/255. alpha:1];
}

+ (UIColor *)favouriteColor
{
    //return [UIColor colorWithRed:241/255. green:196/255. blue:15/255. alpha:1];
    return [UIColor brandColor];
}

@end
