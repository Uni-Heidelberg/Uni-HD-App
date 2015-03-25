//
//  UHDModule.h
//  uni-hd
//
//  Created by Nils Fischer on 26.04.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

@import RestKit;
@import UHDPersistenceKit;
@protocol UHDRemoteDatasourceDelegate;


@interface UHDRemoteDatasource : NSObject

@property (weak, nonatomic) id <UHDRemoteDatasourceDelegate> delegate;

- (id)initWithPersistentStack:(UHDPersistentStack *)persistentStack remoteBaseURL:(NSURL *)baseURL;

- (void)refreshWithCompletion:(void (^)(BOOL success, NSError *error))completion;

- (void)generateSampleDataIfNeeded;

@end


@protocol UHDRemoteDatasourceDelegate <NSObject>

- (void)remoteDatasource:(UHDRemoteDatasource *)remoteDatasource setupObjectMappingForObjectManager:(RKObjectManager *)objectManager;
- (NSArray *)remoteRefreshPathsForRemoteDatasource:(UHDRemoteDatasource *)remoteDatasource;

@optional
- (void)remoteDatasource:(UHDRemoteDatasource *)remoteDatasource didRefreshRemotePath:(NSString *)remotePath managedObjectContext:(NSManagedObjectContext *)managedObjectContext error:(NSError *)error;
- (BOOL)remoteDatasource:(UHDRemoteDatasource *)remoteDatasource shouldGenerateSampleDataForManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
- (void)remoteDatasource:(UHDRemoteDatasource *)remoteDatasource generateSampleDataForManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end
