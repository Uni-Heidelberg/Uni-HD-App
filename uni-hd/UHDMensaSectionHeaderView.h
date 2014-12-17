//
//  UHDMensaSectionHeaderView.h
//  uni-hd
//
//  Created by Felix on 15.12.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UHDMensaSectionHeaderView : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UILabel *sectionHeaderLabel;
@property (nonatomic, readonly, retain) IBOutlet UIView *contentView;
- (IBAction)mensenButtonPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *mensenButton;

@end

