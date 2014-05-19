//
//  UHDNewsItemCell+ConfigureForItem.m
//  uni-hd
//
//  Created by Kevin Geier on 14.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDNewsItemCell+ConfigureForItem.h"
#import "UHDNewsSource.h"

@implementation UHDNewsItemCell (ConfigureForItem)

- (void)configureForItem:(UHDNewsItem *)item {
    self.titleLabel.text = item.title;
    self.abstractLabel.text = item.abstract;
    self.sourceLabel.text = item.source.title;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.yyyy"];
    
    self.dateLabel.text = [dateFormatter stringFromDate:item.date];
}

@end
