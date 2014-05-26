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
@dynamic color;
@dynamic newsItems;
@dynamic category;

- (NSMutableSet *)mutableNewsItems
{
    return [self mutableSetValueForKey:@"newsItems"];
}

@end
