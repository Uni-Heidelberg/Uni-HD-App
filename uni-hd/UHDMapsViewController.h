//
//  UHDMapsViewController.h
//  uni-hd
//
//  Created by Nils Fischer on 22.06.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

@import UIKit;
#import "UHDRemoteManagedLocation.h"

@interface UHDMapsViewController : UIViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (void)showLocation:(UHDRemoteManagedLocation *)location animated:(BOOL)animated;

@end
