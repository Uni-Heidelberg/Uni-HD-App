//
//  UHDTalkDetailTitleCell.m
//  uni-hd
//
//  Created by Kevin Geier on 13.04.15.
//  Copyright (c) 2015 Universit&#228;t Heidelberg. All rights reserved.
//

#import "UHDTalkDetailTitleCell.h"


@interface UHDTalkDetailTitleCell ()

@property (weak, nonatomic) IBOutlet UITextView *titleTextView;

@end


@implementation UHDTalkDetailTitleCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureForItem:(UHDTalkItem *)item {

	self.titleTextView.text = item.title;
	self.titleTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
	
}

@end
