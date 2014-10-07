//
//  UHDTalkItemCell.h
//  uni-hd
//
//  Created by Kevin Geier on 07.07.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import	"UHDAutoLayoutMultilineLabel.h"

@interface UHDTalkItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UHDAutoLayoutMultilineLabel *titleLabel;
@property (weak, nonatomic) IBOutlet UHDAutoLayoutMultilineLabel *speakerLabel;
@property (weak, nonatomic) IBOutlet UHDAutoLayoutMultilineLabel *affiliationLabel;
@property (weak, nonatomic) IBOutlet UHDAutoLayoutMultilineLabel *dateLabel;
@property (weak, nonatomic) IBOutlet UHDAutoLayoutMultilineLabel *locationLabel;
@property (weak, nonatomic) IBOutlet UHDAutoLayoutMultilineLabel *abstractLabel;
@property (weak, nonatomic) IBOutlet UIImageView *talkImageView;

@end
