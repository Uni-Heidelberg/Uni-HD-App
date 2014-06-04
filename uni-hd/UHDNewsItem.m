//
//  UHDNewsItem.m
//  uni-hd
//
//  Created by Kevin Geier on 14.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDNewsItem.h"


@implementation UHDNewsItem

@dynamic title;
@dynamic date;
@dynamic abstract;
@dynamic read;
@dynamic url;
@dynamic thumbImageData;
@dynamic source;


#pragma mark - Convenience accessors

- (UIImage *)thumbImage
{
    // TODO: cache in property, but figure out correct way to overwrite core data setter method first
    return [UIImage imageWithData:self.thumbImageData];
}

- (void)setThumbImage:(UIImage *)thumbImage
{
    self.thumbImageData = UIImageJPEGRepresentation(thumbImage, 1);
}

@end
