//
//  UHDModule.h
//  uni-hd
//
//  Created by Nils Fischer on 26.04.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//


@interface UHDModuleStore : NSObject

+ (instancetype)defaultStore;

- (NSManagedObjectContext *)managedObjectContext;

- (NSArray *)allItems;

- (void)generateSampleDataConditionally:(BOOL)conditionally;
- (void)generateSampleData;

@end
