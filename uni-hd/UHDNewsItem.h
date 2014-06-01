//
//  UHDNewsItem.h
//  uni-hd
//
//  Created by Kevin Geier on 14.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@class UHDNewsSource;


@interface UHDNewsItem : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSString *abstract;
@property (nonatomic) BOOL read;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSData *thumbImageData;
@property (nonatomic, retain) UHDNewsSource *source;

- (UIImage *)thumbImage;
- (void)setThumbImage:(UIImage *)thumbImage;

@end
