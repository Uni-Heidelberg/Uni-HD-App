//
//  UHDPersistentStack.h
//  uni-hd
//
//  Created by Nils Fischer on 14.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

@import Foundation;
@import CoreData;
#import <RestKit/RestKit.h>


@interface UHDPersistentStack : NSObject

- (id)initWithManagedObjectModel:(NSManagedObjectModel *)managedObjectModel persistentStoreURL:(NSURL *)persistentStoreURL;

- (NSManagedObjectContext *)managedObjectContext;
- (RKManagedObjectStore *)managedObjectStore;

@end
