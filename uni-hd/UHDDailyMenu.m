//
//  UHDDailyMenu.m
//  uni-hd
//
//  Created by Felix on 14.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDDailyMenu.h"
#import "UHDMeal.h"
#import "UHDMensa.h"


@implementation UHDDailyMenu

@dynamic date;
@dynamic meals;
@dynamic section;

- (NSMutableSet *)mutableMeals
{
    return [self mutableSetValueForKey:@"meals"];
}

@end
