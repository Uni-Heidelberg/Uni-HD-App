//
//  UHDDailyMenuViewController.h
//  uni-hd
//
//  Created by Felix on 14.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

@import UIKit;
#import "UHDMensa.h"

@interface UHDDailyMenuViewController : UITableViewController

@property (strong, nonatomic) UHDMensa *mensa;
@property (strong, nonatomic) NSDate *date;

@end
