//
//  UHDNewsCategorySourceCell+ConfigureForCategorySource.h
//  uni-hd
//
//  Created by Andreas Schachner on 22.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDNewsCategorySourceCell.h"
#import "UHDNewsCategory.h"
#import "UHDNewsSource.h"

@interface UHDNewsCategorySourceCell (ConfigureForCategorySource)

- (void)configureForItem:(UHDNewsSource *)item;

@end
