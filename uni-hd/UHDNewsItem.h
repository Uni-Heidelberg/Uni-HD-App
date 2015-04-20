//
//  UHDNewsItem.h
//  uni-hd
//
//  Created by Kevin Geier on 14.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

@import Foundation;

typedef enum : NSUInteger {
    UHDSectioningPeriodEarlier = 0,
    UHDSectioningPeriodLast7days,
    UHDSectioningPeriodYesterday,
	UHDSectioningPeriodToday,
	UHDSectioningPeriodTomorrow,
	UHDSectioningPeriodNext7days,
	UHDSectioningPeriodLater,
} UHDSectioningPeriod;


@import UHDRemoteKit;
@class UHDNewsSource;

@interface UHDNewsItem : UHDRemoteManagedObject

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSString *abstract;
@property (nonatomic) BOOL read;
@property (nonatomic, retain) NSURL *url;
@property (nonatomic, retain) NSData *imageData;
@property (nonatomic, retain) NSURL *imageURL;
@property (nonatomic, retain) NSString *buildingString;
@property (nonatomic, retain) NSString *roomString;
@property (nonatomic, retain) UHDNewsSource *source;

@property (nonatomic, retain) NSString *sectionIdentifier;

@property (nonatomic, readonly) UIImage *image;

// TODO: replace me
@property (nonatomic, readonly) NSString *content;

- (void)resetSectionIdentifierCache;

@end
