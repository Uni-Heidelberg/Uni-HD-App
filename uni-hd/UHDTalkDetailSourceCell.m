//
//  UHDTalkDetailSourceCell.m
//  uni-hd
//
//  Created by Kevin Geier on 13.04.15.
//  Copyright (c) 2015 Universit&#228;t Heidelberg. All rights reserved.
//

#import "UHDTalkDetailSourceCell.h"
#import "UHDNewsSource.h"

@interface UHDTalkDetailSourceCell ()

@property (weak, nonatomic) IBOutlet UIImageView *sourceImageView;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;


@end

@implementation UHDTalkDetailSourceCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureForItem:(UHDTalkItem *)item {

	self.sourceImageView.image = item.source.image;
	self.sourceImageView.layer.cornerRadius = self.sourceImageView.bounds.size.height / 2.;
	self.sourceImageView.layer.masksToBounds = YES;
	
	self.sourceLabel.text = item.source.title;
	
	[self setNeedsLayout];
	[self layoutIfNeeded];
}

@end
