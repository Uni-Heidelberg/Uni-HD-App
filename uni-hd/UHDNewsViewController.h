//
//  UHDNewsViewController.h
//  uni-hd
//
//  Created by Nils Fischer on 06.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

@import Foundation;
@import UIKit;


@interface UHDNewsViewController : UITableViewController

- (void)setRemoteDatasource:(id<UHDRemoteDatasource>)remoteDatasource;

@end
