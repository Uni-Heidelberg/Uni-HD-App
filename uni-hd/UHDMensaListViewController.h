//
//  UHDMensaViewController.h
//  uni-hd
//
//  Created by Felix on 07.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

@import Foundation;
@import UIKit;
#import "UHDSelectMensaDelegateProtocol.h"
#import "UHDMensaCell.h"

@interface UHDMensaListViewController : UITableViewController <RMSwipeTableViewCellDelegate,CLLocationManagerDelegate>
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property CLLocationManager *locationManager;


@end
