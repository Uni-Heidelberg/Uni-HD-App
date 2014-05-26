//
//  UHDNewsSourceCell+ConfigureForSource.m
//  uni-hd
//
//  Created by Nils Fischer on 26.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDNewsSourceCell+ConfigureForSource.h"
#import "UHDNewsItem.h"


@implementation UHDNewsSourceCell (ConfigureForSource)

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self.subscribedSwitch addTarget:self action:@selector(subscribedSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)dealloc
{
    [self.source removeObserver:self forKeyPath:@"subscribed"];
}

- (void)configureForSource:(UHDNewsSource *)source
{
    self.titleLabel.text = source.title;

    [self.source removeObserver:self forKeyPath:@"subscribed"];
    self.source = source;
    [self.source addObserver:self forKeyPath:@"subscribed" options:NSKeyValueObservingOptionInitial context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object==self.source) {
        [self.subscribedSwitch setOn:self.source.subscribed animated:YES];
    }
}

- (void)subscribedSwitchValueChanged:(id)sender
{
    if (self.source.subscribed != self.subscribedSwitch.on) {
        self.source.subscribed = self.subscribedSwitch.on;
        [self.source.managedObjectContext saveToPersistentStore:NULL];
    }
}

@end
