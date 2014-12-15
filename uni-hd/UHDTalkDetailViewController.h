//
//  UHDTalkDetailViewController.h
//  uni-hd
//
//  Created by Kevin Geier on 11.12.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UHDTalkItem.h"
#import "UHDTalkSpeaker.h"

@interface UHDTalkDetailViewController : UITableViewController

@property (strong, nonatomic) UHDTalkItem *talkItem;

@end
