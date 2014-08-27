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

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSSet *locations;

- (NSMutableSet *)mutableLocations;

@end
