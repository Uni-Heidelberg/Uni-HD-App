//
//  UHDMensa.h
//  uni-hd
//
//  Created by Felix on 14.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UHDDailyMenu, UHDLocation;

@interface UHDMensa : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) UHDLocation *location;
@property (nonatomic, retain) NSSet *menus;
@property (nonatomic, retain) NSSet *sections;


- (NSMutableSet *)mutableMenus;
- (NSMutableSet *)mutableSections;
@end


