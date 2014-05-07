//
//  UHDLocation.h
//  uni-hd
//
//  Created by Nils Fischer on 07.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UHDMensa;

@interface UHDLocation : NSManagedObject

@property (nonatomic) double longitude;
@property (nonatomic) double latitude;
@property (nonatomic, retain) UHDMensa *mensa;

@end
