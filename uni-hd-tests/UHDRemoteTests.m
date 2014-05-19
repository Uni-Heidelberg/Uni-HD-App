//
//  uni_hd_tests.m
//  uni-hd-tests
//
//  Created by Nils Fischer on 19.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

@import XCTest;
#import <RestKit/RestKit.h>


@interface UHDRemoteTests : XCTestCase

@property (strong, nonatomic) RKManagedObjectStore *managedObjectStore;

@end

@implementation UHDRemoteTests

- (void)setUp
{
    [super setUp];
    self.managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:[[NSManagedObjectModel mergedModelFromBundles:nil] mutableCopy]];
    XCTAssertNotNil([self.managedObjectStore addInMemoryPersistentStore:nil], @"Failed to create in-memory persistent store");
    [self.managedObjectStore createManagedObjectContexts];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testManagedObjectStore
{
    XCTAssertNotNil(self.managedObjectStore, @"No managed Object Store");
}

@end
