//
//  UHDRemoteDatasourceDelegateManager.m
//  uni-hd
//
//  Created by Nils Fischer on 21.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDRemoteDatasourceManager.h"


@interface UHDRemoteDatasourceManager ()

@property (strong, nonatomic) NSMutableDictionary *remoteDatasources;

@end


@implementation UHDRemoteDatasourceManager

- (void)addRemoteDatasource:(UHDRemoteDatasource *)remoteDatasource forKey:(NSString *)key
{
    if (!self.remoteDatasources) self.remoteDatasources = [[NSMutableDictionary alloc] init];
    [self.remoteDatasources setObject:remoteDatasource forKey:key];
}

- (UHDRemoteDatasource *)remoteDatasourceForKey:(NSString *)key
{
    return self.remoteDatasources[key];
}

- (NSArray *)allRemoteDatasources
{
    return [self.remoteDatasources allValues];
}

- (void)refreshAllWithCompletion:(void (^)(BOOL success, NSError *error))completion
{
    
    __block int refreshQueue = 0;
    __block BOOL successAll = YES;
    for (UHDRemoteDatasource *remoteDatasource in self.allRemoteDatasources) {
        refreshQueue++;
        [remoteDatasource refreshWithCompletion:^(BOOL success, NSError *error) {
            refreshQueue--;
            if (!success) successAll = NO;
            if (refreshQueue == 0) {
                if (completion) completion(successAll, nil);
            }
        }];
    }
}

- (void)generateAllSampleDataIfNeeded
{
    for (UHDRemoteDatasource *remoteDatasource in self.allRemoteDatasources) {
        [remoteDatasource generateSampleDataIfNeeded];
    }
}

@end
