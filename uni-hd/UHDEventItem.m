//
//  UHDEvent.m
//  uni-hd
//
//  Created by Kevin Geier on 30.06.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDEventItem.h"
#import "UHDRemoteManagedLocation.h"

@implementation UHDEventItem

@dynamic buildingString, roomString;
@dynamic location;

- (NSString *)formattedLocation {
    if (self.location) {
        return self.location.title;
    } else {
        return [NSString stringWithFormat:@"%@, %@", self.buildingString, self.roomString];
    }
}

- (BOOL)read {

	NSDate *today = [NSDate date];
	
	if ([self.date compare:today] == NSOrderedAscending) {
		return YES;
	}
	else {
		return NO;
	}
}

@end
