//
//  UHDSection.h
//  uni-hd
//
//  Created by Felix on 14.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

@import UHDRemoteKit;
@class UHDDailyMenu, UHDMensa;

@interface UHDMensaSection : UHDRemoteManagedObject

@property (nonatomic, retain) NSString *title;

@property (nonatomic, retain) UHDMensa *mensa;
@property (nonatomic, retain) NSSet *menus;
- (NSMutableSet *)mutableMenus;

- (UHDDailyMenu *)dailyMenuForDate:(NSDate *)date;

@end

