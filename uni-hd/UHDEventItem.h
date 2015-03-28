//
//  UHDEvent.h
//  uni-hd
//
//  Created by Kevin Geier on 30.06.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

@import Foundation;
#import "UHDNewsItem.h"
@class Location;

@interface UHDEventItem : UHDNewsItem

@property (nonatomic, retain) NSString *buildingString;
@property (nonatomic, retain) NSString *roomString;
@property (nonatomic, retain) Location *location;

@property (nonatomic, readonly) NSString *formattedLocation;

@end
