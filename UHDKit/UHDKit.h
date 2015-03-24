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
// Model
#import <UHDKit/UHDMensa.h>


// News

// View Controllers
#import <UHDKit/UHDNewsViewController.h>
#import <UHDKit/UHDNewsDetailViewController.h>
#import <UHDKit/UHDNewsSourcesViewController.h>
#import <UHDKit/UHDTalkDetailViewController.h>
// View
#import <UHDKit/UHDNewsItemCell.h>
#import <UHDKit/UHDTalkItemCell.h>
// Model
#import <UHDKit/UHDNewsSource.h>
#import <UHDKit/UHDNewsItem.h>
#import <UHDKit/UHDEventItem.h>
#import <UHDKit/UHDTalkItem.h>


// Maps

// View Controllers
#import <UHDKit/UHDMapsViewController.h>
// Model
#import <UHDKit/UHDRemoteManagedLocation.h>
#import <UHDKit/UHDCampusRegion.h>
#import <UHDKit/UHDBuilding.h>
#import <UHDKit/UHDLocationCategory.h>
#import <UHDKit/UHDAddress.h>


// Remote Datasource Delegates

#import <UHDKit/UHDMensaRemoteDatasourceDelegate.h>
#import <UHDKit/UHDNewsRemoteDatasourceDelegate.h>
#import <UHDKit/UHDMapsRemoteDatasourceDelegate.h>


// Global

#import <UHDKit/VILogger.h>
#import <UHDKit/UIColor+UHDColors.h>
#import <UHDKit/NSManagedObject+VIInsertIntoContextCategory.h>
