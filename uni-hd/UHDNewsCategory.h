//
//  UHDNewsCategory.h
//  uni-hd
//
//  Created by Andreas Schachner on 21.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

@import CoreData;

@interface UHDNewsCategory : NSManagedObject

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSSet *sources;

- (NSMutableSet *)mutableSources;

@end
