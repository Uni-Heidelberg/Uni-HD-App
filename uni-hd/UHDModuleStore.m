//
//  UHDModule.m
//  uni-hd
//
//  Created by Nils Fischer on 26.04.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDModuleStore.h"


@interface UHDModuleStore ()

@end


@implementation UHDModuleStore

- (id)initWithPersistentStack:(UHDPersistentStack *)persistentStack
{
    if ((self = [super init])) {
        self.persistentStack = persistentStack;
    }
    return self;
}

- (NSManagedObjectContext *)managedObjectContext
{
    return self.persistentStack.managedObjectContext;
}

- (void)refresh
{
    // TODO: implement server communication
    return;
}

- (NSArray *)allItems
{
    // to be overridden
    return nil;
}

- (void)generateSampleData
{
    // to be overridden
}


@end
