//
//  UHDModule.h
//  uni-hd
//
//  Created by Nils Fischer on 26.04.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDRemoteDatasource.h"
#import "UHDPersistentStack.h"


@interface UHDModuleStore : NSObject <UHDRemoteDatasource>

@property (strong, nonatomic) UHDPersistentStack *persistentStack;

- (id)initWithPersistentStack:(UHDPersistentStack *)persistentStack;

@end
