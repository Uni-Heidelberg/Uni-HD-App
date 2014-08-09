//
//  UHDMensaCell.m
//  uni-hd
//
//  Created by Felix on 09.08.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDMensaCell.h"

@implementation UHDMensaCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)setIsFavourite:(Boolean)isFavourite {
    self.mensa.isFavourite = isFavourite;
}
- (Boolean)isFavourite {
    return self.mensa.isFavourite;
}

@end
