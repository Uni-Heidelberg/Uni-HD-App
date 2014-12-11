//
//  UHDNewsSource.h
//  uni-hd
//
//  Created by Kevin Geier on 19.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDNewsCategory.h"

@interface UHDNewsSource : UHDNewsCategory

@property (nonatomic) BOOL subscribed;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSURL *relativeImageURL;
@property (nonatomic, retain) NSData *imageData;
@property (nonatomic, retain) NSSet *newsItems;

- (NSMutableSet *)mutableNewsItems;

@property (nonatomic, readonly) NSURL *imageURL;
@property (nonatomic, readonly) UIImage *image;
@property (nonatomic) UHDNewsCategory *category;

@end
