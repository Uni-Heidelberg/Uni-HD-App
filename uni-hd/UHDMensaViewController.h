//
//  UHDMensaViewController.h
//  uni-hd
//
//  Created by Felix on 07.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

@import Foundation;
@import UIKit;

@interface UHDMensaViewController : UITableViewController <UIActionSheetDelegate>

- (void)setRemoteDatasource:(id<UHDRemoteDatasource>)remoteDatasource;
- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end
