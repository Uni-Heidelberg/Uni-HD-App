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

- (void)refreshWithCompletion:(void (^)(BOOL success, NSError *error))completion
{
    NSArray *remoteRefreshPaths = [self.delegate remoteRefreshPathsForRemoteDatasource:self];
    if (!remoteRefreshPaths) {
        // TODO: present NSError
        [self.logger log:@"Refresh Failed: remote refresh paths not set" forLevel:VILogLevelError];
        if (completion) completion(NO, nil);
        return;
    }
    
    [self.logger log:@"Refresh started ..." object:remoteRefreshPaths forLevel:VILogLevelVerbose];
    
    for (NSString *remoteRefreshPath in remoteRefreshPaths) {
        // TODO: implement queue / call completion only once
        [self.objectManager getObjectsAtPath:remoteRefreshPath parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            [self.logger log:@"Refresh successful" object:mappingResult forLevel:VILogLevelVerbose];
            if (completion) completion(YES, nil);
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            [self.logger log:@"Refresh failed" error:error];
            if (completion) completion(NO, error);
        }];
    }
    
}

- (NSArray *)allItems
{
    return [self.delegate remoteDatasource:self allItemsForManagedObjectContext:self.persistentStack.managedObjectContext];
}

- (void)generateSampleData {
    [self.delegate remoteDatasource:self generateSampleDataForManagedObjectContext:self.persistentStack.managedObjectContext];
}

@end
