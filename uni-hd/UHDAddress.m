//
//  UHDAddress.m
//  uni-hd
//
//  Created by Nils Fischer on 15.12.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDAddress.h"

@implementation UHDAddress

@dynamic street, postalCode, city;

- (NSString *)formattedDescription {
    return [NSString stringWithFormat:@"%@,\n%@ %@", self.street, self.postalCode, self.city];
}

@end
