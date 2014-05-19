//
//  UHDDatabaseTests.m
//  uni-hd
//
//  Created by Nils Fischer on 19.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

@import XCTest;
@import CoreData;


@interface UHDDatabaseTests : XCTestCase

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end


@implementation UHDDatabaseTests

- (void)setUp
{
    [super setUp];
    
    // Merge all models in main bundle
    self.managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    // Create persistent store and add model
    self.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    NSError *error = nil;
    XCTAssertNotNil([self.persistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:&error], @"Failed to add persistent store with error: %@", error);
    
    // Create MOC
    self.managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    self.managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testCoreDataStack
{
    XCTAssertNotNil(self.managedObjectContext.persistentStoreCoordinator.managedObjectModel, @"Failed to create core data stack");
}

@end
