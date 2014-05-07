//
//  UHDNewsViewController.h
//  uni-hd
//
//  Created by Nils Fischer on 06.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

@import Foundation;
@import UIKit;

@class UHDNewsStore;


@interface UHDNewsViewController : UITableViewController

@property (strong, nonatomic) UHDNewsStore *store;

@end
