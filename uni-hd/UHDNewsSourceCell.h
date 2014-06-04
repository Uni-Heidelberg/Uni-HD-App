//
//  UHDNewsSourceCell.h
//  uni-hd
//
//  Created by Nils Fischer on 26.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

@import UIKit;
@class UHDNewsSource;


@interface UHDNewsSourceCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UISwitch *subscribedSwitch;
@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;

@property (strong, nonatomic) UHDNewsSource *source;

@end
