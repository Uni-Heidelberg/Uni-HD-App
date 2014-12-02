//
//  UHDMapsSearchTableViewController.h
//  uni-hd
//
//  Created by Andreas Schachner on 13.08.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

@import Foundation;
@import UIKit;
#import "UHDBuilding.h"

@protocol UHDMapsSearchResultsViewControllerDelegate;

@interface UHDMapsSearchResultsViewController : UITableViewController <UISearchResultsUpdating>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) id<UHDMapsSearchResultsViewControllerDelegate> delegate;

@end

@protocol UHDMapsSearchResultsViewControllerDelegate

- (void)searchResultsViewController:(UHDMapsSearchResultsViewController *)viewController didSelectBuilding:(UHDBuilding *)building;

@end