//
//  UHDNewsCategorySourceCell+ConfigureForCategorySource.m
//  uni-hd
//
//  Created by Andreas Schachner on 22.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDNewsCategorySourceCell+ConfigureForCategorySource.h"
#import "UHDNewsCategory.h"
#import "UHDNewsSource.h"

@implementation UHDNewsCategorySourceCell (ConfigureForCategorySource)

- (void)configureForItem:(UHDNewsSource *)item {
    
    self.sourceLabel.text = item.title;
    
}



@end
