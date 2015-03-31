//
//  UHDModule.m
//  uni-hd
//
//  Created by Nils Fischer on 26.04.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDRemoteDatasource.h"
#import "UHDPersistentStack.h"
#import "VILogger.h"

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
    
    [self.logger log:@"Refresh started ..." object:remoteRefreshPaths forLevel:VILogLevelInfo];
    
    __block int refreshQueue = 0;
    __block BOOL successAll = YES;
    for (NSString *remoteRefreshPath in remoteRefreshPaths) {
        refreshQueue++;
        [self.objectManager getObjectsAtPath:remoteRefreshPath parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            refreshQueue--;
            [self.logger log:[NSString stringWithFormat:@"Refresh successful, %i remaining.", refreshQueue] object:remoteRefreshPath forLevel:VILogLevelInfo];
            [self.logger log:@"Mapping result" object:mappingResult forLevel:VILogLevelVerbose];
            if ([self.delegate respondsToSelector:@selector(remoteDatasource:didRefreshRemotePath:managedObjectContext:error:)]) {
                [self.delegate remoteDatasource:self didRefreshRemotePath:remoteRefreshPath managedObjectContext:self.persistentStack.managedObjectContext error:nil];
            }
            if (refreshQueue==0) {
                if (completion) completion(successAll, nil);
            }
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            refreshQueue--;
            successAll = NO;
            [self.logger log:[NSString stringWithFormat:@"Refresh failed, %i remaining.", refreshQueue] error:error];
            if ([self.delegate respondsToSelector:@selector(remoteDatasource:didRefreshRemotePath:managedObjectContext:error:)]) {
                [self.delegate remoteDatasource:self didRefreshRemotePath:remoteRefreshPath managedObjectContext:self.persistentStack.managedObjectContext error:error];
            }
            if (refreshQueue==0) {
                if (completion) completion(successAll, nil);
            }
        }];
    }
    
}

- (void)generateSampleDataIfNeeded
{
    if ([self.delegate respondsToSelector:@selector(remoteDatasource:shouldGenerateSampleDataForManagedObjectContext:)] && [self.delegate remoteDatasource:self shouldGenerateSampleDataForManagedObjectContext:self.persistentStack.managedObjectContext] && [self.delegate respondsToSelector:@selector(remoteDatasource:generateSampleDataForManagedObjectContext:)]) {
        [self.delegate remoteDatasource:self generateSampleDataForManagedObjectContext:self.persistentStack.managedObjectContext];
    }
}

@end
