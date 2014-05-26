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
    RKEntityMapping *newsItemMapping = [RKEntityMapping mappingForEntityForName:@"UHDNewsItem" inManagedObjectStore:objectManager.managedObjectStore];
    //newsItemMapping.identificationAttributes = @[ @"id" ];
    [newsItemMapping addAttributeMappingsFromArray:@[ @"title", @"date", @"abstract", @"url" ]];
    
    RKResponseDescriptor *newsItemResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:newsItemMapping method:RKRequestMethodGET pathPattern:@"UHDNewsItems" keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    [objectManager addResponseDescriptor:newsItemResponseDescriptor];

    RKEntityMapping *newsSourceMapping = [RKEntityMapping mappingForEntityForName:@"UHDNewsSource" inManagedObjectStore:objectManager.managedObjectStore];
    //newsItemMapping.identificationAttributes = @[ @"id" ];
    [newsSourceMapping addAttributeMappingsFromArray:@[ @"title" ]];
    
    RKResponseDescriptor *newsSourceResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:newsSourceMapping method:RKRequestMethodGET pathPattern:@"UHDNewsSources" keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    [objectManager addResponseDescriptor:newsSourceResponseDescriptor];
}

- (NSString *)remoteRefreshPathForRemoteDatasource:(UHDRemoteDatasource *)remoteDatasource
{
    return @"UHDNewsSources";
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
    newsItem.title = @"Breaking News!";
    newsItem.abstract = @"But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.";
    newsItem.date = [NSDate date];
    newsItem.url = @"http://www.loremipsum.de/index_e.html";
    NSData *imageData = UIImagePNGRepresentation([UIImage imageNamed:@"kip"]);
    newsItem.thumb = imageData;
    newsItem.source = newsSource;
    
    newsItem = [UHDNewsItem insertNewObjectIntoContext:managedObjectContext];
    newsItem.title = @"Bahnbrechende Neuigkeiten!";
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
    imageData = UIImagePNGRepresentation([UIImage imageNamed:@"heidelberg"]);
    newsItem.thumb = imageData;
    
    // Save to store
    [managedObjectContext saveToPersistentStore:NULL];
}

@end
