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
    
    newsItem = [UHDNewsItem insertNewObjectIntoContext:self.managedObjectContext];
    newsItem.title = @"Even more exciting News.";
    
    newsItem = [UHDNewsItem insertNewObjectIntoContext:self.managedObjectContext];
    newsItem.title = @"HTML News";
    newsItem.date = [NSDate date];
    
    NSString *htmlContent = @"<html><head><title>Title here!</title></head><body bgcolor=\"#CCFFFF\">An <h1>iOS App</h1> for the University of Heidelberg will be available soon.</body></html>";
    
    newsItem.content = htmlContent;
    
    [newsItem.managedObjectContext save:NULL];
}

@end
