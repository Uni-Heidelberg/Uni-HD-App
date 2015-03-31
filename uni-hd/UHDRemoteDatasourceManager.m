//
//  UHDRemoteDatasourceDelegateManager.m
//  uni-hd
//
//  Created by Nils Fischer on 21.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDRemoteDatasourceManager.h"
#import "VILogger.h"

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

- (NSTimeInterval)timeIntervalSinceRefresh {
    NSDate *lastRefreshDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"UHDUserDefaultsKeyLastRefresh"];
    if (!lastRefreshDate) {
        return -1;
    } else {
        return -[lastRefreshDate timeIntervalSinceNow];
    }
}

- (void)refreshAllWithCompletion:(void (^)(BOOL success, NSError *error))completion
{
    [self.logger log:@"Refreshing all datasources..." forLevel:VILogLevelInfo];
    __block int refreshQueue = 0;
    __block BOOL successAll = YES;
    for (UHDRemoteDatasource *remoteDatasource in self.allRemoteDatasources) {
        refreshQueue++;
        [remoteDatasource refreshWithCompletion:^(BOOL success, NSError *error) {
            refreshQueue--;
            [self.logger log:@"Datasources remaining in refresh queue:" object:@(refreshQueue) forLevel:VILogLevelDebug];
            if (!success) successAll = NO;
            if (refreshQueue == 0) {
                [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"UHDUserDefaultsKeyLastRefresh"];
                [self.logger log:@"Refreshing all datasources complete." forLevel:VILogLevelInfo];
                if (completion) completion(successAll, nil);
            }
        }];
    }
}

@end
