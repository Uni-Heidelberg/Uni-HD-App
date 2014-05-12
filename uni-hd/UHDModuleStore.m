//
//  UHDModule.m
//  uni-hd
//
//  Created by Nils Fischer on 26.04.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDModuleStore.h"

#import "UHDAppDelegate.h"

@interface UHDModuleStore ()

@end


@implementation UHDModuleStore


#pragma mark - Singleton

static NSMutableDictionary *defaultStores;

+ (instancetype)defaultStore {
    id defaultStore = nil;
    
    @synchronized(self) {
        NSString *storeClassKey = NSStringFromClass(self);
        
        defaultStore = [defaultStores objectForKey:storeClassKey];
        
        if (!defaultStore) {
            defaultStore = [[self alloc] init];
            if (!defaultStores) defaultStores = [[NSMutableDictionary alloc] init];
            [defaultStores setObject:defaultStore forKey:storeClassKey];
        }
    }
    
    return defaultStore;
}


#pragma mark - Core Data Stack access

- (NSManagedObjectContext *)managedObjectContext {
    return [(UHDAppDelegate *)[UIApplication sharedApplication].delegate managedObjectContext];
}


#pragma mark - Utility

- (NSArray *)allItems
{
    // to be overridden
    return nil;
}


#pragma mark - Sample Data

- (void)generateSampleDataConditionally:(BOOL)conditionally
{
    if (conditionally && self.allItems.count > 0) return;
    [self generateSampleData];
}

- (void)generateSampleData
{
    // to be overridden
}


@end
