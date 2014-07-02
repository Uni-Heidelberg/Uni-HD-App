//
//  UHDNewsSource.m
//  uni-hd
//
//  Created by Kevin Geier on 19.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDNewsSource.h"

@implementation UHDNewsSource

@dynamic subscribed;
@dynamic title;
@dynamic thumbIconData;
@dynamic newsItems;
@dynamic category;

- (NSMutableSet *)mutableNewsItems
{
    return [self mutableSetValueForKey:@"newsItems"];
}

#pragma mark - Convenience accessors

- (UIImage *)thumbIcon
{
    // TODO: cache in property, but figure out correct way to overwrite core data setter method first
    return [UIImage imageWithData:self.thumbIconData];
}


- (void)setThumbIcon:(UIImage *)thumbIcon
{
    self.thumbIconData = UIImagePNGRepresentation(thumbIcon);
}


- (UHDNewsCategory *) category
{
	return self.parent;
}


- (void) setCategory:(UHDNewsCategory *)category
{
	self.parent = category;
}


@end
