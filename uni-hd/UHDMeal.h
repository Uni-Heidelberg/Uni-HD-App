//
//  UHDMeal.h
//  uni-hd
//
//  Created by Felix on 14.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDRemoteManagedObject.h"

@interface UHDMeal : UHDRemoteManagedObject

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSNumber *priceStud;
@property (nonatomic, retain) NSNumber *priceBed;
@property (nonatomic, retain) NSNumber *priceGuest;
@property (nonatomic) BOOL isFavourite;
@property (nonatomic) BOOL isVegetarian;

@property (nonatomic, retain) NSSet *menus;
- (NSMutableSet *)mutableMenus;

@property (nonatomic, readonly) NSString *localizedPriceDescription;
@property (nonatomic, readonly) NSString *localizedExtrasDescription;

@end
