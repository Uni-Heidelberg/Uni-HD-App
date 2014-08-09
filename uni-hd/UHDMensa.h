//
//  UHDMensa.h
//  uni-hd
//
//  Created by Felix on 14.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDRemoteManagedLocation.h"
@class UHDDailyMenu;

@interface UHDMensa : UHDRemoteManagedLocation

@property (nonatomic, retain) NSSet *menus;
@property (nonatomic, retain) NSSet *sections;
@property (nonatomic, assign) Boolean isFavourite;

- (NSMutableSet *)mutableMenus;
- (NSMutableSet *)mutableSections;
- (UHDDailyMenu *)dailyMenuForDate:(NSDate *)date;

@end


