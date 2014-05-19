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
@dynamic articles;

- (NSMutableSet *)mutableArticles
{
    return [self mutableSetValueForKey:@"articles"];
}

@end
