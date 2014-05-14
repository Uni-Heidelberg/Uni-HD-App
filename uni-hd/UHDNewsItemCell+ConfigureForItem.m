//
//  UHDNewsItemCell+ConfigureForItem.m
//  uni-hd
//
//  Created by Kevin Geier on 14.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDNewsItemCell+ConfigureForItem.h"

@implementation UHDNewsItemCell (ConfigureForItem)

- (void)configureForItem:(UHDNewsItem *)item {
    self.titleLabel.text = item.title;
    self.abstractLabel.text = item.content;
}

@end
