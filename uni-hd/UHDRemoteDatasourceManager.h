//
//  UHDRemoteDatasourceDelegateManager.h
//  uni-hd
//
//  Created by Nils Fischer on 21.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "VIManager.h"
#import "UHDRemoteDatasource.h"


@interface UHDRemoteDatasourceManager : VIManager

- (void)addRemoteDatasource:(UHDRemoteDatasource *)remoteDatasource forKey:(NSString *)key;
- (UHDRemoteDatasource *)remoteDatasourceForKey:(NSString *)key;
- (NSArray *)allRemoteDatasources;
- (void)refreshAllWithCompletion:(void (^)(BOOL success, NSError *error))completion;

@end
