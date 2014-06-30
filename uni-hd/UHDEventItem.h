//
//  UHDEvent.h
//  uni-hd
//
//  Created by Kevin Geier on 30.06.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDNewsItem.h"

@interface UHDEventItem : UHDNewsItem

@property (nonatomic, retain) NSString *location;
@property (nonatomic, retain) NSString *eventType;

@end
