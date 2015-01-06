//
//  UHDNewsListViewController.h
//  uni-hd
//
//  Created by Nils Fischer on 20.06.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UHDNewsViewController.h"


@interface UHDNewsListViewController : UITableViewController

@property (strong, nonatomic) NSArray *sources;
@property (nonatomic) UHDNewsEventsDisplayMode displayMode;

@property (nonatomic) NSUInteger pageIndex;

- (void)scrollToToday;

@end
