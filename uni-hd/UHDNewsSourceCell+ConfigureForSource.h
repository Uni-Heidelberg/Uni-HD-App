//
//  UHDNewsSourceCell+ConfigureForSource.h
//  uni-hd
//
//  Created by Nils Fischer on 26.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDNewsSourceCell.h"
#import "UHDNewsSource.h"
#import "UIColor+UHDBrandColor.h"

@interface UHDNewsSourceCell (ConfigureForSource)

- (void)configureForSource:(UHDNewsSource *)source;

- (void)subscribedSwitchValueChanged:(id)sender;

@end
