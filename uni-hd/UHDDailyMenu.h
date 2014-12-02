//
//  UHDDailyMenu.h
//  uni-hd
//
//  Created by Felix on 14.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDRemoteManagedObject.h"

@class UHDMeal, UHDMensaSection;

@interface UHDDailyMenu : UHDRemoteManagedObject

@property (nonatomic, retain) NSDate *date;

@property (nonatomic, retain) UHDMensaSection *section;
@property (nonatomic, retain) NSOrderedSet *meals;
- (NSMutableOrderedSet *)mutableMeals;

@end


