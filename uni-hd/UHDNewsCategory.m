//
//  UHDNewsCategory.m
//  uni-hd
//
//  Created by Andreas Schachner on 21.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDNewsCategory.h"
#import "UHDNewsSource.h"

@implementation UHDNewsCategory

@dynamic title, children, parent;

- (NSMutableSet *)mutableChildren
{
    return [self mutableSetValueForKey:@"children"];
}

- (int)subscribedCount {
    int count = 0;
    for (UHDNewsCategory *child in self.children) {
        count += [child subscribedCount];
    }
    return count;
}

@end
