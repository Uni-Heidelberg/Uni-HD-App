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
@property (nonatomic, retain) NSData *thumbIconData;
@property (nonatomic, retain) NSSet *newsItems;
@property (nonatomic) UHDNewsCategory *category;

- (NSMutableSet *)mutableNewsItems;

- (UIImage *)thumbIcon;
- (void)setThumbIcon:(UIImage *)thumbIcon;

@end
