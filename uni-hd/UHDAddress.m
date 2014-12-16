//
//  UHDAddress.m
//  uni-hd
//
//  Created by Nils Fischer on 15.12.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDAddress.h"
#import <AddressBook/AddressBook.h>

@implementation UHDAddress

@dynamic street, postalCode, city;

- (NSString *)formattedDescription {
    return [NSString stringWithFormat:@"%@,\n%@ %@", self.street, self.postalCode, self.city];
}

- (NSDictionary *)addressDictionary {
    return @{ (NSString *)kABPersonAddressStreetKey: self.street, (NSString *)kABPersonAddressZIPKey: self.postalCode, (NSString *)kABPersonAddressCityKey: self.city };
}

@end
