//
//  UHDEvent.m
//  uni-hd
//
//  Created by Kevin Geier on 30.06.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDEventItem.h"

@implementation UHDEventItem

@dynamic location;

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
