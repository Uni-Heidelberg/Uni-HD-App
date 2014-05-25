//
//  UHDNewsSource.h
//  uni-hd
//
//  Created by Kevin Geier on 19.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>
@class UHDNewsCategory;


@interface UHDNewsSource : NSManagedObject

@property (nonatomic) BOOL subscribed;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *color;
@property (nonatomic, retain) NSSet *articles;
@property (nonatomic, retain) UHDNewsCategory *sources;

- (NSMutableSet *)mutableArticles;

@end
