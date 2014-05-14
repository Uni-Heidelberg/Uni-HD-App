//
//  UHDMensaModule.m
//  uni-hd
//
//  Created by Nils Fischer on 26.04.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDNewsStore.h"
#import "UHDNewsItem.h"

@implementation UHDNewsStore

- (NSArray *)allItems
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[UHDNewsItem entityName]];
    NSError *error = nil;
    NSArray *allItems = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (error) {
        [self.logger log:@"Fetching all items" error:error];
    }
    return allItems;
}

- (void)generateSampleData
{
    UHDNewsItem *newsItem = [UHDNewsItem insertNewObjectIntoContext:self.managedObjectContext];
    newsItem.title = @"Breaking News!";
    [newsItem.managedObjectContext save:NULL];
    
    newsItem = [UHDNewsItem insertNewObjectIntoContext:self.managedObjectContext];
    newsItem.title = @"Even more exciting News.";
    [newsItem.managedObjectContext save:NULL];
}

@end
