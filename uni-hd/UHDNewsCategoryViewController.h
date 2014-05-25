//
//  UHDNewsCategoryViewController.h
//  uni-hd
//
//  Created by Andreas Schachner on 21.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Foundation;
@import UIKit;

@interface UHDNewsCategoryViewController : UITableViewController

- (void)setRemoteDatasource:(id<UHDRemoteDatasource>)remoteDatasource;
- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end
