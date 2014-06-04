//
//  UHDModule.h
//  uni-hd
//
//  Created by Nils Fischer on 26.04.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import <RestKit/RestKit.h>
@class UHDPersistentStack;
@protocol UHDRemoteDatasourceDelegate;


@interface UHDRemoteDatasource : NSObject

@property (weak, nonatomic) id <UHDRemoteDatasourceDelegate> delegate;

- (id)initWithPersistentStack:(UHDPersistentStack *)persistentStack remoteBaseURL:(NSURL *)baseURL;

- (void)refreshWithCompletion:(void (^)(BOOL success, NSError *error))completion;

- (NSArray *)allItems;
- (void)generateSampleData;

@end


@protocol UHDRemoteDatasourceDelegate

- (void)remoteDatasource:(UHDRemoteDatasource *)remoteDatasource setupObjectMappingForObjectManager:(RKObjectManager *)objectManager;
- (NSString *)remoteRefreshPathForRemoteDatasource:(UHDRemoteDatasource *)remoteDatasource;
- (NSArray *)remoteDatasource:(UHDRemoteDatasource *)remoteDatasource allItemsForManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
- (void)remoteDatasource:(UHDRemoteDatasource *)remoteDatasource generateSampleDataForManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end
