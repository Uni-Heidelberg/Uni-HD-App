//
//  CoreDataTests.m
//  CoreDataTests
//
//  Created by Nils Fischer on 27.04.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface CoreDataTests : XCTestCase

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation CoreDataTests

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
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCoreDataStack
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"NewsItem"];
    NSError *error = nil;
    XCTAssertNotNil([self.managedObjectContext executeFetchRequest:fetchRequest error:&error], @"Failed to execute fetch request: %@", error);
}

@end
