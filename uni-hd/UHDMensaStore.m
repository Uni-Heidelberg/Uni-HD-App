//
//  UHDMensaStore.m
//  uni-hd
//
//  Created by Nils Fischer on 12.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDMensaStore.h"
#import "UHDMensa.h"

@implementation UHDMensaStore

- (NSArray *)allItems
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[UHDMensa entityName]];
    NSError *error = nil;
    NSArray *allItems = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (error) {
        [self.logger log:@"Fetching all items" error:error];
    }
    return allItems;
}

- (void)generateSampleData
{
    UHDMensa *mensaItem = [UHDMensa insertNewObjectIntoContext:self.managedObjectContext];
    mensaItem.title = @"Marstall";
    [mensaItem.managedObjectContext save:NULL];
    
    mensaItem = [UHDMensa insertNewObjectIntoContext:self.managedObjectContext];
    mensaItem.title = @"Zentralmensa INF";
    [mensaItem.managedObjectContext save:NULL];
}

@end
