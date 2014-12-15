//
//  UHDAddress.h
//  uni-hd
//
//  Created by Nils Fischer on 15.12.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface UHDAddress : NSManagedObject

@property (nonatomic, retain) NSString *street;
@property (nonatomic, retain) NSString *postalCode;
@property (nonatomic, retain) NSString *city;

@property (nonatomic, readonly) NSString *formattedDescription;

@end
