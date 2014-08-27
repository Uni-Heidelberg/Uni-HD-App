//
//  UHDLocation.h
//  uni-hd
//
//  Created by Nils Fischer on 08.08.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDRemoteManagedObject.h"

@interface UHDRemoteManagedLocation : UHDRemoteManagedObject <MKAnnotation>

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, strong) NSString *buildingNumber;
@property (nonatomic, retain) NSString *imageName;
@property (nonatomic) double_t latitude;
@property (nonatomic) double_t longitude;

@end
