//
//  UHDNewsSource.h
//  uni-hd
//
//  Created by Kevin Geier on 19.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDRemoteManagedObject.h"
@class UHDNewsCategory;


@interface UHDNewsSource : UHDRemoteManagedObject

@property (nonatomic) BOOL subscribed;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *color;
@property (nonatomic, retain) NSSet *newsItems;
@property (nonatomic, retain) UHDNewsCategory *category;

- (NSMutableSet *)mutableNewsItems;

@end
