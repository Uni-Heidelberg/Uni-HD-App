//
//  UHDNewsSourceCell.h
//  uni-hd
//
//  Created by Nils Fischer on 26.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

@import UIKit;
#import "UHDNewsSource.h"

@interface UHDNewsSourceCell : UITableViewCell

- (void)configureForSource:(UHDNewsSource *)source;

@end
