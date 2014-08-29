//
//  UHDMapsViewController.h
//  uni-hd
//
//  Created by Nils Fischer on 22.06.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

@import UIKit;

//Model
#import "UHDBuilding.h"

@interface UHDMapsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UISegmentedControl *mapType;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
- (IBAction)changeMapType:(id)sender;


@end
