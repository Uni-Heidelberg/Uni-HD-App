//
//  UHDAutoLayoutMultilineLabel.m
//  uni-hd
//
//  Created by Kevin Geier on 07.10.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDAutoLayoutMultilineLabel.h"

@implementation UHDAutoLayoutMultilineLabel : UILabel

- (void)setBounds:(CGRect)bounds {
  if (bounds.size.width != self.bounds.size.width) {
    [self setNeedsUpdateConstraints];
  }
  [super setBounds:bounds];
}

- (void)updateConstraints {
  if (self.preferredMaxLayoutWidth != self.bounds.size.width) {
    self.preferredMaxLayoutWidth = self.bounds.size.width;
  }
  [super updateConstraints];
}

@end