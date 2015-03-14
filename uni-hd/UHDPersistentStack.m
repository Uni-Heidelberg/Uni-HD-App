//
//  UHDPersistentStack.m
//  uni-hd
//
//  Created by Nils Fischer on 14.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDPersistentStack.h"


@interface UHDPersistentStack ()

@property (strong, nonatomic) RKManagedObjectStore *managedObjectStore;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end


@implementation UHDPersistentStack


- (id)init {
    return nil;
}

- (id)initWithManagedObjectModel:(NSManagedObjectModel *)managedObjectModel persistentStoreURL:(NSURL *)persistentStoreURL {
    
    if ((self = [super init])) {

        // setup persistent store coordinater
        self.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
        NSError *error = nil;
        if (![self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:persistentStoreURL options:@{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES} error:&error]) {
            
            //[self.logger log:@"Failed adding Persistent Store" error:error];
            abort();
            
        }

        // setup RestKit store
        self.managedObjectStore = [[RKManagedObjectStore alloc] initWithPersistentStoreCoordinator:self.persistentStoreCoordinator];
        [self.managedObjectStore createManagedObjectContexts];
        
    }
    return self;
}

- (NSManagedObjectContext *)managedObjectContext
{
    return self.managedObjectStore.mainQueueManagedObjectContext;
}

@end
