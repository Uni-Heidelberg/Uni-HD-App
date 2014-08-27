//
//  UHDLocationCategory.h
//  uni-hd
//
//  Created by Andreas Schachner on 22.08.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDRemoteManagedObject.h"
#import "UHDBuilding.h"

@interface UHDLocationCategory : UHDRemoteManagedObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSArray *children;
@property (strong, nonatomic) NSDictionary *dictionary;

@end
