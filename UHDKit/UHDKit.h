//
//  UHDKit.h
//  UHDKit
//
//  Created by Nils Fischer on 14.03.15.
//  Copyright (c) 2015 Universit&#228;t Heidelberg. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for UHDKit.
FOUNDATION_EXPORT double UHDKitVersionNumber;

//! Project version string for UHDKit.
FOUNDATION_EXPORT const unsigned char UHDKitVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <UHDKit/PublicHeader.h>


// Mensa

// View Controllers
#import <UHDKit/UHDMensaViewController.h>
#import <UHDKit/UHDDailyMenuViewController.h>
#import <UHDKit/UHDMensaListViewController.h>
// Model
#import <UHDKit/UHDDailyMenu.h>
#import <UHDKit/UHDMeal.h>
#import <UHDKit/UHDMensaSection.h>


// News

// View Controllers
#import <UHDKit/UHDNewsViewController.h>
#import <UHDKit/UHDNewsDetailViewController.h>
#import <UHDKit/UHDNewsSourcesViewController.h>
#import <UHDKit/UHDTalkDetailViewController.h>
#import <UHDKit/UHDNewsListViewController.h>
// View
#import <UHDKit/UHDNewsItemCell.h>
#import <UHDKit/UHDTalkItemCell.h>
#import <UHDKit/UHDEventItemCell.h>
#import <UHDKit/UHDNewsSourceCell.h>
#import <UHDKit/UHDNewsSourcesNavigationBar.h>
#import <UHDKit/UHDReadIndicatorView.h>
#import <UHDKit/UHDSourceCollectionViewCell.h>
#import <UHDKit/UHDTalkDetailSpaceTimeCell.h>
#import <UHDKit/UHDTalkDetailTitleAbstractCell.h>
// Model
#import <UHDKit/UHDNewsSource.h>
#import <UHDKit/UHDNewsItem.h>
#import <UHDKit/UHDEventItem.h>
#import <UHDKit/UHDTalkItem.h>


// Maps

// View Controllers
#import <UHDKit/UHDConfigureMapViewController.h>
#import <UHDKit/UHDMapsSearchResultsViewController.h>
// View
#import <UHDKit/UHDBuildingAnnotationView.h>
#import <UHDKit/UHDBuildingCell.h>


// Remote Datasource Delegates

#import <UHDKit/UHDMensaRemoteDatasourceDelegate.h>
#import <UHDKit/UHDNewsRemoteDatasourceDelegate.h>
#import <UHDKit/UHDMapsRemoteDatasourceDelegate.h>


// Global

#import <UHDKit/UIColor+UHDColors.h>
#import <UHDKit/NSManagedObject+VIInsertIntoContextCategory.h>
#import <UHDKit/VIFetchedResultsControllerDataSource.h>
