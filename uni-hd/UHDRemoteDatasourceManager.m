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

@end
