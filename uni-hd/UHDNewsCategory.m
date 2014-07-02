//
//  UHDNewsCategory.m
//  uni-hd
//
//  Created by Andreas Schachner on 21.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDNewsCategory.h"

@implementation UHDNewsCategory

@dynamic title, children, parent;

- (NSMutableSet *)mutableChildren
{
    return [self mutableSetValueForKey:@"children"];
}

@end
