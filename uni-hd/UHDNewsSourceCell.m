//
//  UHDNewsSourceCell.m
//  uni-hd
//
//  Created by Nils Fischer on 26.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDNewsSourceCell.h"

@interface UHDNewsSourceCell ()

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UISwitch *subscribedSwitch;
@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;

@property (strong, nonatomic) UHDNewsSource *source;

- (IBAction)subscribedSwitchValueChanged:(id)sender;

@end

@implementation UHDNewsSourceCell

- (void)dealloc
{
    [self.source removeObserver:self forKeyPath:@"subscribed"];
}

- (void)configureForSource:(UHDNewsSource *)source
{
    self.titleLabel.text = source.title;
    self.iconImageView.image = source.thumbIcon;
    
    self.subscribedSwitch.on = source.subscribed;
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
