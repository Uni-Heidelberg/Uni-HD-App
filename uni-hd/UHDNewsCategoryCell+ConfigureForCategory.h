//
//  UHDNewsCategoryCell+ConfigureForCategory.h
//  uni-hd
//
//  Created by Andreas Schachner on 21.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDNewsCategoryCell.h"
#import "UHDNewsSource.h"

@interface UHDNewsCategoryCell (ConfigureForCategory)

- (void)configureForItem:(UHDNewsSource *)item;

@end
