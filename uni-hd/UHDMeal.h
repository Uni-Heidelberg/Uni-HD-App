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
@property (nonatomic, retain) NSString *price;
@property (nonatomic, assign) Boolean isFavourite;

@property (nonatomic, retain) NSSet *menus;
- (NSMutableSet *)mutableMenus;

@end
