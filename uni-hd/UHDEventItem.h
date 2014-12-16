//
//  UHDEvent.h
//  uni-hd
//
//  Created by Kevin Geier on 30.06.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDNewsItem.h"
@class UHDRemoteManagedLocation;

@interface UHDEventItem : UHDNewsItem

@property (nonatomic, retain) NSString *buildingString;
@property (nonatomic, retain) NSString *roomString;
@property (nonatomic, retain) UHDRemoteManagedLocation *location;

@property (nonatomic, readonly) NSString *formattedLocation;

@end
