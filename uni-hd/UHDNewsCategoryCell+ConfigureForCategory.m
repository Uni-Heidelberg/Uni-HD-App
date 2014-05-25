//
//  UHDNewsCategoryCell+ConfigureForCategory.m
//  uni-hd
//
//  Created by Andreas Schachner on 21.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDNewsCategoryCell+ConfigureForCategory.h"
#import "UHDNewsCategory.h"

@implementation UHDNewsCategoryCell (ConfigureForCategory)

- (void)configureForItem:(UHDNewsSource *)item {
    
    self.categoryLabel.text = item.category.title;
    
}



@end
