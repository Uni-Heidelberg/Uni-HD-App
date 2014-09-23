//
//  UHDDailyMenuViewController.h
//  uni-hd
//
//  Created by Felix on 14.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UHDDailyMenu.h"

@interface UHDDailyMenuViewController : UITableViewController

@property (strong, nonatomic) UHDDailyMenu *dailyMenu;

/// To store date if no daily menu object is set
@property (strong, nonatomic) NSDate *date;

@end
