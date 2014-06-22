//
//  UHDMensa.h
//  uni-hd
//
//  Created by Felix on 14.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDRemoteManagedObject.h"
@class UHDDailyMenu, UHDLocation;

@interface UHDMensa : UHDRemoteManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) UHDLocation *location;
@property (nonatomic, retain) NSSet *menus;
@property (nonatomic, retain) NSSet *sections;

- (NSMutableSet *)mutableMenus;
- (NSMutableSet *)mutableSections;
- (UHDDailyMenu *)dailyMenuForDate:(NSDate *)date;

@end


