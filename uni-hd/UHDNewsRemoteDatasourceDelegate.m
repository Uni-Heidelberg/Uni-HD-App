//
//  UHDMensaModule.m
//  uni-hd
//
//  Created by Nils Fischer on 26.04.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDNewsRemoteDatasourceDelegate.h"
#import "UHDNewsItem.h"
#import "UHDEventItem.h"
#import "UHDTalkItem.h"
#import "UHDTalkSpeaker.h"
#import "UHDNewsSource.h"
#import "UHDNewsCategory.h"

@implementation UHDNewsRemoteDatasourceDelegate

- (void)remoteDatasource:(UHDRemoteDatasource *)remoteDatasource setupObjectMappingForObjectManager:(RKObjectManager *)objectManager
{
    
    // UHDNewsCategory
    
    RKEntityMapping *newsCategoryMapping = [RKEntityMapping mappingForEntityForName:[UHDNewsCategory entityName] inManagedObjectStore:objectManager.managedObjectStore];
    [newsCategoryMapping addAttributeMappingsFromDictionary:@{@"id": @"remoteObjectId"}];
    [newsCategoryMapping addAttributeMappingsFromArray:@[ @"title", @"parentId" ]];
    newsCategoryMapping.identificationAttributes = @[ @"remoteObjectId" ];
    newsCategoryMapping.identificationPredicate = [NSPredicate predicateWithFormat:@"entity == %@", newsCategoryMapping.entity];
    [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:newsCategoryMapping method:RKRequestMethodAny pathPattern:@"categories" keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    RKConnectionDescription *newsCategoryParentConnection = [[RKConnectionDescription alloc] initWithRelationship:[newsCategoryMapping.entity relationshipsByName][@"parent"] attributes:@{ @"parentId": @"remoteObjectId" }];
    newsCategoryParentConnection.includesSubentities = NO;
    [newsCategoryMapping addConnection:newsCategoryParentConnection];
    // Stubs
    RKEntityMapping *newsCategoryStubMapping = [RKEntityMapping mappingForEntityForName:[UHDNewsCategory entityName] inManagedObjectStore:objectManager.managedObjectStore];
    [newsCategoryStubMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:nil toKeyPath:@"remoteObjectId"]];
    newsCategoryStubMapping.identificationAttributes = @[ @"remoteObjectId" ];
    newsCategoryStubMapping.identificationPredicate = [NSPredicate predicateWithFormat:@"entity == %@", newsCategoryStubMapping.entity];
    [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:newsCategoryStubMapping method:RKRequestMethodAny pathPattern:@"sources" keyPath:@"categoryId" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];

    
    // UHDNewsSource
    
    RKEntityMapping *newsSourceMapping = [RKEntityMapping mappingForEntityForName:[UHDNewsSource entityName] inManagedObjectStore:objectManager.managedObjectStore];
    [newsSourceMapping addAttributeMappingsFromDictionary:@{@"id": @"remoteObjectId", @"name": @"title", @"imageUrl": @"imageURL"}];
    [newsSourceMapping addAttributeMappingsFromArray:@[ @"categoryId" ]];
    newsSourceMapping.identificationAttributes = @[ @"remoteObjectId" ];
    newsSourceMapping.identificationPredicate = [NSPredicate predicateWithFormat:@"entity == %@", newsSourceMapping.entity];
    RKConnectionDescription *newsSourceParentConnection = [[RKConnectionDescription alloc] initWithRelationship:[newsSourceMapping.entity relationshipsByName][@"parent"] attributes:@{ @"categoryId": @"remoteObjectId" }];
    newsSourceParentConnection.includesSubentities = NO;
    [newsSourceMapping addConnection:newsSourceParentConnection];
    [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:newsSourceMapping method:RKRequestMethodAny pathPattern:@"sources" keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    // Stubs
    RKEntityMapping *newsSourceStubMapping = [RKEntityMapping mappingForEntityForName:[UHDNewsSource entityName] inManagedObjectStore:objectManager.managedObjectStore];
    [newsSourceStubMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:nil toKeyPath:@"remoteObjectId"]];
    newsSourceStubMapping.identificationAttributes = @[ @"remoteObjectId" ];
    newsSourceStubMapping.identificationPredicate = [NSPredicate predicateWithFormat:@"entity == %@", newsSourceStubMapping.entity];
    [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:newsSourceStubMapping method:RKRequestMethodAny pathPattern:@"articles" keyPath:@"sourceId" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];

    // UHDNewsItem
    
    RKEntityMapping *newsItemMapping = [RKEntityMapping mappingForEntityForName:[UHDNewsItem entityName] inManagedObjectStore:objectManager.managedObjectStore];
    [newsItemMapping addAttributeMappingsFromDictionary:@{@"id": @"remoteObjectId", @"imageUrl": @"imageURL" }];
    [newsItemMapping addAttributeMappingsFromArray:@[ @"title", @"date", @"abstract", @"url", @"sourceId" ]];
    newsItemMapping.identificationAttributes = @[ @"remoteObjectId" ];
    newsItemMapping.identificationPredicate = [NSPredicate predicateWithFormat:@"entity == %@", newsItemMapping.entity];
    RKConnectionDescription *newsItemSourceConnection = [[RKConnectionDescription alloc] initWithRelationship:[newsItemMapping.entity relationshipsByName][@"source"] attributes:@{ @"sourceId": @"remoteObjectId" }];
    newsItemSourceConnection.includesSubentities = NO;
    [newsItemMapping addConnection:newsItemSourceConnection];
    [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:newsItemMapping method:RKRequestMethodGET pathPattern:@"articles" keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];

    // UHDEventItem
    
    RKEntityMapping *eventItemMapping = [RKEntityMapping mappingForEntityForName:[UHDEventItem entityName] inManagedObjectStore:objectManager.managedObjectStore];
    [eventItemMapping addAttributeMappingsFromDictionary:@{@"id": @"remoteObjectId", @"building": @"location", @"imageUrl": @"imageURL" }];
    [eventItemMapping addAttributeMappingsFromArray:@[ @"title", @"date", @"abstract", @"url", @"sourceId" ]];
    eventItemMapping.identificationAttributes = @[ @"remoteObjectId" ];
    eventItemMapping.identificationPredicate = [NSPredicate predicateWithFormat:@"entity == %@", eventItemMapping.entity];
    RKConnectionDescription *eventItemSourceConnection = [[RKConnectionDescription alloc] initWithRelationship:[eventItemMapping.entity relationshipsByName][@"source"] attributes:@{ @"sourceId": @"remoteObjectId" }];
    eventItemSourceConnection.includesSubentities = NO;
    [eventItemMapping addConnection:eventItemSourceConnection];
    [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:eventItemMapping method:RKRequestMethodGET pathPattern:@"events" keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];

    // UHDTalkSpeaker
    
    RKEntityMapping *speakerMapping = [RKEntityMapping mappingForEntityForName:[UHDTalkSpeaker entityName] inManagedObjectStore:objectManager.managedObjectStore];
    [speakerMapping addAttributeMappingsFromArray:@[ @"name", @"affiliation", @"email", @"url", @"talkId" ]];

    // UHDTalkItem
    
    RKEntityMapping *talkItemMapping = [RKEntityMapping mappingForEntityForName:[UHDTalkItem entityName] inManagedObjectStore:objectManager.managedObjectStore];
    [talkItemMapping addAttributeMappingsFromDictionary:@{@"id": @"remoteObjectId", @"building": @"location", @"imageUrl": @"imageURL" }];
    [talkItemMapping addAttributeMappingsFromArray:@[ @"title", @"date", @"abstract", @"url", @"sourceId" ]];
    [talkItemMapping addRelationshipMappingWithSourceKeyPath:@"speaker" mapping:speakerMapping];
    talkItemMapping.identificationAttributes = @[ @"remoteObjectId" ];
    talkItemMapping.identificationPredicate = [NSPredicate predicateWithFormat:@"entity == %@", talkItemMapping.entity];
    RKConnectionDescription *talkItemSourceConnection = [[RKConnectionDescription alloc] initWithRelationship:[talkItemMapping.entity relationshipsByName][@"source"] attributes:@{ @"sourceId": @"remoteObjectId" }];
    talkItemSourceConnection.includesSubentities = NO;
    [talkItemMapping addConnection:talkItemSourceConnection];
    [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:talkItemMapping method:RKRequestMethodGET pathPattern:@"talks" keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    

}

- (NSArray *)remoteRefreshPathsForRemoteDatasource:(UHDRemoteDatasource *)remoteDatasource
{
    return @[ @"categories", @"sources", @"articles", @"events", @"talks?speaker=object" ];
}

- (BOOL)remoteDatasource:(UHDRemoteDatasource *)remoteDatasource shouldGenerateSampleDataForManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[UHDNewsItem entityName]];
    NSArray *allItems = [managedObjectContext executeFetchRequest:fetchRequest error:NULL];
    return allItems.count == 0;
}

- (void)remoteDatasource:(UHDRemoteDatasource *)remoteDatasource generateSampleDataForManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{    
    // Create NewsSource object with category
    UHDNewsCategory *newsCategory = [UHDNewsCategory insertNewObjectIntoContext:managedObjectContext];
    newsCategory.title = @"[SAMPLE] Physik";
    UHDNewsSource *newsSource = [UHDNewsSource insertNewObjectIntoContext:managedObjectContext];
    newsSource.title = @"[SAMPLE] Fakultät für Physik und Astronomie";
    newsSource.category = newsCategory;
    newsSource.subscribed = YES;

    // Create NewsArticles
    UHDNewsItem *newsItem = [UHDNewsItem insertNewObjectIntoContext:managedObjectContext];
    newsItem.title = @"[SAMPLE] Unbelievable exceptional breaking News!";
    newsItem.abstract = @"But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.";
    newsItem.date = [NSDate date];
    newsItem.url = [NSURL URLWithString:@"http://www.loremipsum.de/index_e.html"];
    //newsItem.thumbImage = [UIImage imageNamed:@"kip"];
    newsItem.source = newsSource;
    
    newsItem = [UHDNewsItem insertNewObjectIntoContext:managedObjectContext];
    newsItem.title = @"[SAMPLE] Wirklich bahnbrechende Neuigkeiten!";
    newsItem.abstract = @"Damit Ihr indess erkennt, woher";
		//dieser ganze Irrthum gekommen ist, und weshalb man die Lust anklagt und den Schmerz lobet, so will ich Euch Alles eröffnen und auseinander setzen, was jener Begründer der Wahrheit und gleichsam Baumeister des glücklichen Lebens selbst darüber gesagt hat.";
    newsItem.date = [NSDate dateWithTimeIntervalSince1970:0];
    newsItem.url = [NSURL URLWithString:@"http://www.loremipsum.de"];
    // no image for this news
    newsItem.source = newsSource;
	
	
	// Create Talk
	UHDNewsCategory *collocs = [UHDNewsCategory insertNewObjectIntoContext:managedObjectContext];
	collocs.title = @"[SAMPLE] Kolloquien";
	collocs.parent = newsCategory;
	
	newsSource = [UHDNewsSource insertNewObjectIntoContext:managedObjectContext];
	newsSource.title = @"[SAMPLE] Physikalisches Kolloquium";
	newsSource.category = collocs;
	newsSource.subscribed = YES;
	
	UHDTalkItem *talkItem = [UHDTalkItem insertNewObjectIntoContext:managedObjectContext];
	talkItem.title = @"[SAMPLE] Particle Fever";
	talkItem.abstract = @"A exciting film about the LHC at CERN.";
    talkItem.date = [NSDate dateWithTimeIntervalSinceReferenceDate:409251600];
    talkItem.url = [NSURL URLWithString:@"http://www.physi.uni-heidelberg.de/Veranstaltungen/Ankuendigungen/Kaplan_20.12.2013.pdf"];
    //talkItem.thumbImage = [UIImage imageNamed:@"particleFever"];
    talkItem.source = newsSource;
	talkItem.location = @"INF 308, Hörsaal 1";
	
	// Create Speaker
	UHDTalkSpeaker *talkSpeaker = [UHDTalkSpeaker insertNewObjectIntoContext:managedObjectContext];
	talkSpeaker.name = @"Prof. David Kaplan";
	talkSpeaker.affiliation = @"Department of Physics and Astronomy, John Hopkins University";
	talkSpeaker.url = [NSURL URLWithString:@"http://particlefever.com"];
	talkSpeaker.email = @"dkaplan@pha.jhu.edu";
	
	talkItem.speaker = talkSpeaker;
	
	// Create further talk
	newsSource = [UHDNewsSource insertNewObjectIntoContext:managedObjectContext];
	newsSource.title = @"[SAMPLE] Heidelberg Joint Astronomical Colloquium";
	newsSource.category = collocs;
	newsSource.subscribed = YES;
	
	talkItem = [UHDTalkItem insertNewObjectIntoContext:managedObjectContext];
	talkItem.title = @"[SAMPLE] The turbulent life-cycle of molecular clouds";
	//talkItem.abstract = @"This talk is about fundamental mechanisms in the dynamic of quantum many-body systems.";
    talkItem.date = [NSDate dateWithTimeIntervalSinceReferenceDate:426470417];
    talkItem.url = [NSURL URLWithString:@"http://www.ita.uni-heidelberg.de/~dullemond/hjac.shtml?lang=de"];
    //talkItem.thumbImage = [UIImage imageNamed:@"astroTalk"];
    talkItem.source = newsSource;
	talkItem.location = @"Haus der Astronomie on the Königstuhl";

	// Create Speaker
	talkSpeaker = [UHDTalkSpeaker insertNewObjectIntoContext:managedObjectContext];
	talkSpeaker.name = @"Stefanie Walch";
	talkSpeaker.affiliation = @"Uni Köln";
	talkSpeaker.url = [NSURL URLWithString:@"http://www.astro.uni-koeln.de/walch"];
	talkSpeaker.email = @"walch@ph1.uni-koeln.de";
	
	talkItem.speaker = talkSpeaker;
	

    // Create new NewsSource
    newsCategory = [UHDNewsCategory insertNewObjectIntoContext:managedObjectContext];
    newsCategory.title = @"[SAMPLE] Uni Allgemein";
    newsSource = [UHDNewsSource insertNewObjectIntoContext:managedObjectContext];
    newsSource.title = @"[SAMPLE] Universität Heidelberg";
    newsSource.category = newsCategory;
    newsSource.subscribed = YES;
	
	    
    // Create further NewsArticles
    newsItem = [UHDNewsItem insertNewObjectIntoContext:managedObjectContext];
    newsItem.title = @"[SAMPLE] Novitas!";
    newsItem.abstract = @"Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.";
    newsItem.date = [NSDate dateWithTimeIntervalSinceReferenceDate:(-2000*365.25*24*3600)];
    newsItem.url = [NSURL URLWithString:@"http://www.uni-heidelberg.de"];
    newsItem.source = newsSource;
    //newsItem.thumbImage = [UIImage imageNamed:@"heidelberg"];
	
	
	// Create Events
	newsSource = [UHDNewsSource insertNewObjectIntoContext:managedObjectContext];
	newsSource.title = @"[SAMPLE] Studentenwerk";
	newsSource.subscribed = YES;
	newsSource.category = newsCategory;
	
	UHDEventItem *eventItem = [UHDEventItem insertNewObjectIntoContext:managedObjectContext];
	eventItem.title = @"[SAMPLE] Public Viewing WM-Finale 2014";
	eventItem.date = [NSDate dateWithTimeIntervalSinceReferenceDate:426556822];
	eventItem.url = [NSURL URLWithString:@"http://de.fifa.com/worldcup/matches/index.html"];
	//eventItem.thumbImage = [UIImage imageNamed:@"WM2014"];
	eventItem.source = newsSource;
	eventItem.location = @"Café Botanik im Neuenheimer Feld";
	//eventItem.abstract = @"Ein wahrhaft packendes Spiel - am Ende kann man nur sagen: Super, Mario!";
	
	eventItem = [UHDEventItem insertNewObjectIntoContext:managedObjectContext];
	eventItem.title = @"KinoCafé";
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *oneDay = [[NSDateComponents alloc] init];
	oneDay.day = 1;
	eventItem.date = [calendar dateByAddingComponents:oneDay toDate:[NSDate date] options:0];
	eventItem.url = [NSURL URLWithString:@"https://www.facebook.com/studierendenwerk.heidelberg"];
	eventItem.source = newsSource;
	eventItem.location = @"Marstallcafé";
	eventItem.abstract = @"Morgen läuft der neueste Film von und mit Matthias Schweighöfer. ICI-Clubmitgleider zahlen im Oktober keinen Eintritt. Clubausweise gibt es für 2 Euro ab 18.30 Uhr im Marstallcafé.";
    
    // Save to store
    [managedObjectContext saveToPersistentStore:NULL];
}

@end
