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
@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;

- (IBAction)subscribedSwitchValueChanged:(id)sender;

@end

@implementation UHDNewsSourceCell

- (void)configureForSource:(UHDNewsSource *)source
{
    self.titleLabel.text = source.title;
    self.iconImageView.image = source.image;
    
    self.subscribedSwitch.on = source.subscribed;
}

- (void)subscribedSwitchValueChanged:(id)sender
{
    [self.delegate sourceCellSubscribedValueChanged:self];
}

@end
