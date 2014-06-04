//
//  UHDDailyMenuViewController.h
//  uni-hd
//
//  Created by Felix on 14.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UHDDailyMenu.h"
#import "UHDSelectMensaDelegateProtocol.h"

@interface UHDDailyMenuViewController : UITableViewController<UHDSelectMensaDelegateProtocol>
@property (strong, nonatomic) UHDDailyMenu *dailyMenu;

@end
