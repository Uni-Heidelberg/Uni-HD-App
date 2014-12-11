//
//  UHDNewsSourceCell.h
//  uni-hd
//
//  Created by Nils Fischer on 26.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

@import UIKit;
#import "UHDNewsSource.h"
@protocol UHDNewsSourceCellDelegate;

@interface UHDNewsSourceCell : UITableViewCell

@property (nonatomic, weak) id <UHDNewsSourceCellDelegate> delegate;

@property (strong, nonatomic) IBOutlet UISwitch *subscribedSwitch;

- (void)configureForSource:(UHDNewsSource *)source;

@end

@protocol UHDNewsSourceCellDelegate

- (void)sourceCellSubscribedValueChanged:(UHDNewsSourceCell *)cell;

@end