//
//  UHDMensa.h
//  uni-hd
//
//  Created by Felix on 14.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDBuilding.h"
@class UHDDailyMenu;
@class Hours;

@interface UHDMensa : UHDBuilding

@property (nonatomic, retain) NSSet *menus;
@property (nonatomic, retain) NSSet *sections;
@property (nonatomic, assign) BOOL isFavourite;

@property (nonatomic) CLLocationDistance currentDistance;
@property (readonly) Hours *hours; // TODO: not yet implemented properly
@property (readonly) NSAttributedString * attributedStatusDescription;

- (NSMutableSet *)mutableMenus;
- (NSMutableSet *)mutableSections;
- (UHDDailyMenu *)dailyMenuForDate:(NSDate *)date;

@end


