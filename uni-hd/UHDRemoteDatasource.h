//
//  UHDRemoteDatasource.h
//  uni-hd
//
//  Created by Nils Fischer on 19.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

@import Foundation;
@import CoreData;

@protocol UHDRemoteDatasource

- (void)refresh;
- (void)generateSampleData;

- (NSArray *)allItems;

@end
