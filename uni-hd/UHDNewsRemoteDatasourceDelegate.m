//
//  UHDMensaModule.m
//  uni-hd
//
//  Created by Nils Fischer on 26.04.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDNewsRemoteDatasourceDelegate.h"
#import "UHDNewsItem.h"
#import "UHDNewsSource.h"
#import "UHDNewsCategory.h"

@implementation UHDNewsRemoteDatasourceDelegate

- (void)remoteDatasource:(UHDRemoteDatasource *)remoteDatasource setupObjectMappingForObjectManager:(RKObjectManager *)objectManager
{
    
    // UHDNewsItem
    
    RKEntityMapping *newsItemMapping = [RKEntityMapping mappingForEntityForName:[UHDNewsItem entityName] inManagedObjectStore:objectManager.managedObjectStore];
    [newsItemMapping addAttributeMappingsFromArray:@[ @"id", @"title", @"date", @"abstract", @"url", @"sourceID" ]];
    newsItemMapping.identificationAttributes = @[ @"id" ];
    [newsItemMapping addConnectionForRelationship:@"source" connectedBy:@{ @"sourceID": @"id" }];
    [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:newsItemMapping method:RKRequestMethodGET pathPattern:nil keyPath:@"newsItems" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];

    
    // UHDNewsSource
    
    RKEntityMapping *newsSourceMapping = [RKEntityMapping mappingForEntityForName:[UHDNewsSource entityName] inManagedObjectStore:objectManager.managedObjectStore];
    [newsSourceMapping addAttributeMappingsFromArray:@[ @"id", @"title", @"categoryID" ]];
    newsSourceMapping.identificationAttributes = @[ @"id" ];
    [newsSourceMapping addConnectionForRelationship:@"category" connectedBy:@{ @"categoryID": @"id" }];
    [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:newsSourceMapping method:RKRequestMethodAny pathPattern:nil keyPath:@"newsSources" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];

    
    // UHDNewsCategory
    
     RKEntityMapping *newsCategoryMapping = [RKEntityMapping mappingForEntityForName:[UHDNewsCategory entityName] inManagedObjectStore:objectManager.managedObjectStore];
    [newsCategoryMapping addAttributeMappingsFromArray:@[ @"id", @"title" ]];
    newsCategoryMapping.identificationAttributes = @[ @"id" ];
    [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:newsCategoryMapping method:RKRequestMethodAny pathPattern:nil keyPath:@"newsCategories" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];

}

- (NSString *)remoteRefreshPathForRemoteDatasource:(UHDRemoteDatasource *)remoteDatasource
{
    return @"news";
}

- (NSArray *)remoteDatasource:(UHDRemoteDatasource *)remoteDatasource allItemsForManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[UHDNewsItem entityName]];
    NSError *error = nil;
    NSArray *allItems = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (error) {
        [self.logger log:@"Fetching all items" error:error];
    }
    return allItems;
}

- (void)remoteDatasource:(UHDRemoteDatasource *)remoteDatasource generateSampleDataForManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    // Create NewsSource object with category
    UHDNewsCategory *newsCategory = [UHDNewsCategory insertNewObjectIntoContext:managedObjectContext];
    newsCategory.title = @"Physik";
    UHDNewsSource *newsSource = [UHDNewsSource insertNewObjectIntoContext:managedObjectContext];
    newsSource.title = @"Fakultät für Physik und Astronomie";
    newsSource.category = newsCategory;
    newsSource.subscribed = YES;
    newsSource.color = @"red";

    // Create NewsArticles
    UHDNewsItem *newsItem = [UHDNewsItem insertNewObjectIntoContext:managedObjectContext];
    newsItem.title = @"Unbelievable exceptional breaking News!";
    newsItem.abstract = @"But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.";
    newsItem.date = [NSDate date];
    newsItem.url = @"http://www.loremipsum.de/index_e.html";
    newsItem.thumbImage = [UIImage imageNamed:@"kip"];
    newsItem.source = newsSource;
    
    newsItem = [UHDNewsItem insertNewObjectIntoContext:managedObjectContext];
    newsItem.title = @"Wirklich bahnbrechende Neuigkeiten!";
    newsItem.abstract = @"Damit Ihr indess erkennt, woher dieser ganze Irrthum gekommen ist, und weshalb man die Lust anklagt und den Schmerz lobet, so will ich Euch Alles eröffnen und auseinander setzen, was jener Begründer der Wahrheit und gleichsam Baumeister des glücklichen Lebens selbst darüber gesagt hat.";
    newsItem.date = [NSDate dateWithTimeIntervalSince1970:0];
    newsItem.url = @"http://www.loremipsum.de";
    // no image for this news
    newsItem.source = newsSource;
    
    // Create new NewsSource
    newsCategory = [UHDNewsCategory insertNewObjectIntoContext:managedObjectContext];
    newsCategory.title = @"Uni Allgemein";
    newsSource = [UHDNewsSource insertNewObjectIntoContext:managedObjectContext];
    newsSource.title = @"Universität Heidelberg";
    newsSource.category = newsCategory;
    newsSource.subscribed = YES;
    newsSource.color = @"blue";
    
    // Create further NewsArticles
    newsItem = [UHDNewsItem insertNewObjectIntoContext:managedObjectContext];
    newsItem.title = @"Novitas!";
    newsItem.abstract = @"Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.";
    newsItem.date = [NSDate dateWithTimeIntervalSinceReferenceDate:(-2000*365.25*24*3600)];
    newsItem.url = @"http://www.uni-heidelberg.de";
    newsItem.source = newsSource;
    newsItem.thumbImage = [UIImage imageNamed:@"heidelberg"];
    
    // Save to store
    [managedObjectContext saveToPersistentStore:NULL];
}

@end
