//
//  UHDMeal.h
//  uni-hd
//
//  Created by Felix on 14.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UHDDailyMenu, UHDSection;

@interface UHDMeal : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) UHDDailyMenu *menu;
@property (nonatomic, retain) UHDSection *section;

@end