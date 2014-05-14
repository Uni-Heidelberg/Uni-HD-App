//
//  UHDMensa.m
//  uni-hd
//
//  Created by Felix on 14.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDMensa.h"
#import "UHDDailyMenu.h"
#import "UHDLocation.h"


@implementation UHDMensa

@dynamic title;
@dynamic location;
@dynamic menus;
@dynamic sections;

- (NSMutableSet *)mutableMenus
{
    return [self mutableSetValueForKey:@"menus"];
}
- (NSMutableSet *)mutableSections
{
    return [self mutableSetValueForKey:@"sections"];
}

@end
