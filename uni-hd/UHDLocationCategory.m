//
//  UHDLocationCategory.m
//  uni-hd
//
//  Created by Andreas Schachner on 22.08.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDLocationCategory.h"

@implementation UHDLocationCategory

@dynamic title;
@dynamic buildings;


#pragma mark - Mutable To-Many Accessors

- (NSMutableSet *)mutableBuildings
{
    return [self mutableSetValueForKey:@"buildings"];
}

@end
