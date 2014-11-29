//
//  UHDNewsItem.h
//  uni-hd
//
//  Created by Kevin Geier on 14.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDRemoteManagedObject.h"
@class UHDNewsSource;

@interface UHDNewsItem : UHDRemoteManagedObject

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSString *abstract;
@property (nonatomic) BOOL read;
@property (nonatomic, retain) NSURL *url;
@property (nonatomic, retain) NSData *thumbImageData;
@property (nonatomic, retain) UHDNewsSource *source;

@property (nonatomic, retain) NSDate *simplifiedDate;

- (UIImage *)thumbImage;
- (void)setThumbImage:(UIImage *)thumbImage;

- (NSDate *)simplifiedDate;

- (void)setDate:(NSDate *)date;

@end
