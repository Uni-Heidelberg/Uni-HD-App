//
//  UHDNewsViewController.h
//  uni-hd
//
//  Created by Nils Fischer on 06.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

@import Foundation;
@import UIKit;

typedef enum : NSUInteger {
    UHDNewsEventsDisplayModeNews = 0,
    UHDNewsEventsDisplayModeEvents,
	UHDNewsEventsDisplayModeAll
} UHDNewsEventsDisplayMode;


@interface UHDNewsViewController : UIViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic) UHDNewsEventsDisplayMode displayMode;

@end
