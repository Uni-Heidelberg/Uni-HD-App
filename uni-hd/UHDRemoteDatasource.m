//
//  UHDModule.m
//  uni-hd
//
//  Created by Nils Fischer on 26.04.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDRemoteDatasource.h"
#import "UHDPersistentStack.h"


@interface UHDRemoteDatasource ()

@property (strong, nonatomic) UHDPersistentStack *persistentStack;
@property (strong, nonatomic) RKObjectManager *objectManager;

@end


@implementation UHDRemoteDatasource

- (id)initWithPersistentStack:(UHDPersistentStack *)persistentStack remoteBaseURL:(NSURL *)baseURL
{
    if ((self = [super init])) {
        
        self.persistentStack = persistentStack;
        
        if (baseURL) {
            // setup RestKit Object manager
            self.objectManager = [RKObjectManager managerWithBaseURL:baseURL];
            self.objectManager.managedObjectStore = self.persistentStack.managedObjectStore;
        }
        
    }
    return self;
}

- (void)setDelegate:(id<UHDRemoteDatasourceDelegate>)delegate
{
    if (_delegate==delegate) return;
    _delegate = delegate;
    [self.delegate remoteDatasource:self setupObjectMappingForObjectManager:self.objectManager];
}

- (void)refresh
{
    NSString *remoteRefreshPath = [self.delegate remoteRefreshPathForRemoteDatasource:self];
    if (!remoteRefreshPath) {
        [self.logger log:@"Refresh Failed: remote refresh path not set" forLevel:VILogLevelError];
        return;
    }
    
    [self.logger log:@"Refresh started ..." object:remoteRefreshPath forLevel:VILogLevelVerbose];
    
    [self.objectManager getObjectsAtPath:remoteRefreshPath parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [self.logger log:@"Refresh successful" object:mappingResult forLevel:VILogLevelVerbose];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [self.logger log:@"Refresh failed" error:error];
    }];
}

- (NSArray *)allItems
{
    return [self.delegate remoteDatasource:self allItemsForManagedObjectContext:self.persistentStack.managedObjectContext];
}

- (void)generateSampleData {
    [self.delegate remoteDatasource:self generateSampleDataForManagedObjectContext:self.persistentStack.managedObjectContext];
}

@end
