//
//  UHDMeal.h
//  uni-hd
//
//  Created by Felix on 14.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDRemoteManagedObject.h"

@class UHDDailyMenu, UHDMensaSection;

@interface UHDMeal : UHDRemoteManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * price;
@property (nonatomic, retain) UHDDailyMenu *menu;
@property (nonatomic, retain) UHDMensaSection *section;

@end
