//
//  UHDNewsCategoryViewController.h
//  uni-hd
//
//  Created by Andreas Schachner on 21.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

@import UIKit;
#import "UHDNewsCategory.h"

@interface UHDNewsSourcesViewController : UITableViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) UHDNewsCategory *category;

@end
