//
//  UHDLocation.h
//  uni-hd
//
//  Created by Nils Fischer on 08.08.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDRemoteManagedObject.h"

@class UHDLocationCategory;

@interface UHDRemoteManagedLocation : UHDRemoteManagedObject <MKAnnotation>

@property (nonatomic, retain) NSString *title;
@property (nonatomic) double_t latitude;
@property (nonatomic) double_t longitude;
@property (nonatomic, retain) UHDLocationCategory *category;
@property (nonatomic, retain) NSData *imageData;

@property (nonatomic) UIImage *image;

@end
