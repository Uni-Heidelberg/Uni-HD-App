//
//  UHDMensaStore.m
//  uni-hd
//
//  Created by Nils Fischer on 12.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDMensaRemoteDatasourceDelegate.h"
#import "UHDMensa.h"
#import "UHDDailyMenu.h"
#import "UHDMeal.h"
#import "UHDMensaSection.h"
#import <RKCLLocationValueTransformer/RKCLLocationValueTransformer.h>


@implementation UHDMensaRemoteDatasourceDelegate

- (void)remoteDatasource:(UHDRemoteDatasource *)remoteDatasource setupObjectMappingForObjectManager:(RKObjectManager *)objectManager
{
    
    // Mensa
    
    RKEntityMapping *mensaMapping = [RKEntityMapping mappingForEntityForName:[UHDMensa entityName] inManagedObjectStore:objectManager.managedObjectStore];
    [mensaMapping addAttributeMappingsFromDictionary:@{ @"id": @"remoteObjectId" }];
    RKAttributeMapping *locationMapping = [RKAttributeMapping attributeMappingFromKeyPath:@"location" toKeyPath:@"location"];
    locationMapping.valueTransformer = [RKCLLocationValueTransformer locationValueTransformerWithLatitudeKey:@"lat" longitudeKey:@"lng"];
    [mensaMapping addPropertyMapping:locationMapping];
    [mensaMapping addAttributeMappingsFromArray:@[ @"title" ]];
    mensaMapping.identificationAttributes = @[ @"remoteObjectId" ];
    mensaMapping.identificationPredicate = [NSPredicate predicateWithFormat:@"entity == %@", mensaMapping.entity];
    [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:mensaMapping method:RKRequestMethodAny pathPattern:@"Mensas" keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    // Stubs
    RKEntityMapping *mensaStubMapping = [RKEntityMapping mappingForEntityForName:[UHDMensa entityName] inManagedObjectStore:objectManager.managedObjectStore];
    [mensaStubMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:nil toKeyPath:@"remoteObjectId"]];
    mensaStubMapping.identificationAttributes = @[ @"remoteObjectId" ];
    mensaStubMapping.identificationPredicate = [NSPredicate predicateWithFormat:@"entity == %@", mensaStubMapping.entity];
    [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:mensaStubMapping method:RKRequestMethodAny pathPattern:@"MensaSections" keyPath:@"mensaId" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    
    // Mensa Section
    
    RKEntityMapping *mensaSectionMapping = [RKEntityMapping mappingForEntityForName:[UHDMensaSection entityName] inManagedObjectStore:objectManager.managedObjectStore];
    [mensaSectionMapping addAttributeMappingsFromDictionary:@{ @"id": @"remoteObjectId" }];
    [mensaSectionMapping addAttributeMappingsFromArray:@[ @"title" ]];
    mensaSectionMapping.identificationAttributes = @[ @"remoteObjectId" ];
    mensaSectionMapping.identificationPredicate = [NSPredicate predicateWithFormat:@"entity == %@", mensaSectionMapping.entity];
    [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:mensaSectionMapping method:RKRequestMethodAny pathPattern:@"MensaSections" keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    // Stubs
    RKEntityMapping *mensaSectionStubMapping = [RKEntityMapping mappingForEntityForName:[UHDMensaSection entityName] inManagedObjectStore:objectManager.managedObjectStore];
    [mensaSectionStubMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:nil toKeyPath:@"remoteObjectId"]];
    mensaSectionStubMapping.identificationAttributes = @[ @"remoteObjectId" ];
    mensaSectionStubMapping.identificationPredicate = [NSPredicate predicateWithFormat:@"entity == %@", mensaSectionStubMapping.entity];
    [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:mensaSectionStubMapping method:RKRequestMethodAny pathPattern:@"MensaDailyMenus" keyPath:@"sectionId" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    
    // Daily Menu
    
    RKEntityMapping *dailyMenuMapping = [RKEntityMapping mappingForEntityForName:[UHDDailyMenu entityName] inManagedObjectStore:objectManager.managedObjectStore];
    [dailyMenuMapping addAttributeMappingsFromDictionary:@{@"id": @"remoteObjectId"}];
    [dailyMenuMapping addAttributeMappingsFromArray:@[ @"date" ]];
    dailyMenuMapping.identificationAttributes = @[ @"remoteObjectId" ];
    dailyMenuMapping.identificationPredicate = [NSPredicate predicateWithFormat:@"entity == %@", dailyMenuMapping.entity];
    [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:dailyMenuMapping method:RKRequestMethodAny pathPattern:@"MensaDailyMenus" keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    // Stubs
    RKEntityMapping *dailyMenuStubMapping = [RKEntityMapping mappingForEntityForName:[UHDDailyMenu entityName] inManagedObjectStore:objectManager.managedObjectStore];
    [dailyMenuStubMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:nil toKeyPath:@"remoteObjectId"]];
    dailyMenuStubMapping.identificationAttributes = @[ @"remoteObjectId" ];
    dailyMenuStubMapping.identificationPredicate = [NSPredicate predicateWithFormat:@"entity == %@", dailyMenuStubMapping.entity];
    [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:dailyMenuStubMapping method:RKRequestMethodAny pathPattern:@"MensaMeals" keyPath:@"menuId" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];

    
    // Meal
    
    RKEntityMapping *mealMapping = [RKEntityMapping mappingForEntityForName:[UHDMeal entityName] inManagedObjectStore:objectManager.managedObjectStore];
    [mealMapping addAttributeMappingsFromDictionary:@{ @"id": @"remoteObjectId", @"priceStud": @"price" }];
    [mealMapping addAttributeMappingsFromArray:@[ @"title" ]];
    mealMapping.identificationAttributes = @[ @"remoteObjectId" ];
    mealMapping.identificationPredicate = [NSPredicate predicateWithFormat:@"entity == %@", mealMapping.entity];
    [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:mealMapping method:RKRequestMethodAny pathPattern:@"MensaMeals" keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
}

- (NSArray *)remoteRefreshPathsForRemoteDatasource:(UHDRemoteDatasource *)remoteDatasource
{
    return @[ @"Mensas", @"MensaSections", @"MensaDailyMenus", @"MensaMeals" ];
}

- (BOOL)remoteDatasource:(UHDRemoteDatasource *)remoteDatasource shouldGenerateSampleDataForManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[UHDMensa entityName]];
    NSArray *allItems = [managedObjectContext executeFetchRequest:fetchRequest error:NULL];
    return allItems.count == 0;
}

- (void)remoteDatasource:(UHDRemoteDatasource *)remoteDatasource generateSampleDataForManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
/*    //FIRST
    //Create Mensa Object
    
    UHDMensa *mensaItem = [UHDMensa insertNewObjectIntoContext:managedObjectContext];
    mensaItem.title = @"[SAMPLE] Marstall";
    mensaItem.image = [UIImage imageNamed:@"marstallhof-01"];
    mensaItem.location = [[CLLocation alloc] initWithLatitude:49.41297656 longitude:8.70445222];
    mensaItem.remoteObjectId = -1;
    
    
    //Create Sections for Mensa
    
    UHDMensaSection *sectionItem = [UHDMensaSection insertNewObjectIntoContext:managedObjectContext];
    sectionItem.title = @"[SAMPLE] Section A";
    sectionItem.remoteObjectId = -1;
    
    UHDMensaSection *sectionItem2 = [UHDMensaSection insertNewObjectIntoContext:managedObjectContext];
    sectionItem2.title = @"[SAMPLE] Section B";
    sectionItem2.remoteObjectId = -2;

    
    [mensaItem.mutableSections addObject:sectionItem];
    
    //Create DailyMenu
    
    UHDDailyMenu *dailyMenuItem = [UHDDailyMenu insertNewObjectIntoContext:managedObjectContext];
    dailyMenuItem.remoteObjectId = -1;
    dailyMenuItem.date = [NSDate date];
    [mensaItem.mutableMenus addObject:dailyMenuItem];
    
    //Create Meal
    
    UHDMeal *mealItem = [UHDMeal insertNewObjectIntoContext:managedObjectContext];
    mealItem.remoteObjectId = -1;
    [dailyMenuItem.mutableMeals addObject:mealItem];
    mealItem.title = @"[SAMPLE] Chefsalat mit Ei";
    mealItem.price = @"2,15 €";
    mealItem.section = sectionItem;
    
    UHDMeal *mealItem4 = [UHDMeal insertNewObjectIntoContext:managedObjectContext];
    mealItem4.remoteObjectId = -2;
    [dailyMenuItem.mutableMeals addObject:mealItem4];
    mealItem4.title = @"[SAMPLE] Chefsalat mit Ei und Käse";
    mealItem4.price = @"2,15 €";
    mealItem4.section = sectionItem2;
	
    UHDMeal *mealItem5 = [UHDMeal insertNewObjectIntoContext:managedObjectContext];
    mealItem5.remoteObjectId = -3;
    [dailyMenuItem.mutableMeals addObject:mealItem5];
    mealItem5.title = @"[SAMPLE] Chefsalat mit Ei und Käse und Soße";
    mealItem5.price = @"2,15 €";
    mealItem5.section = sectionItem;
    
    //SECOND
    //Create Mensa Object
    
    UHDMensa *mensaItem2 = [UHDMensa insertNewObjectIntoContext:managedObjectContext];
    mensaItem2.title = @"[SAMPLE] Zentralmensa";
    mensaItem2.image = [UIImage imageNamed:@"zentralmensa-01"];
    mensaItem2.location = [[CLLocation alloc] initWithLatitude:49.41555917 longitude:8.67088169];
    mensaItem2.remoteObjectId = -2;

    
    //Create Sections for Mensa
    
//    UHDMensaSection *sectionItem2 = [UHDMensaSection insertNewObjectIntoContext:managedObjectContext];
//    sectionItem2.title = @"Section B";
    [mensaItem2.mutableSections addObject:sectionItem2];
    
    //Create DailyMenu
    
    UHDDailyMenu *dailyMenuItem2 = [UHDDailyMenu insertNewObjectIntoContext:managedObjectContext];
    dailyMenuItem2.remoteObjectId = -2;
    dailyMenuItem2.date = [NSDate date];
    [mensaItem2.mutableMenus addObject:dailyMenuItem2];
    
    //Create Meal
    
    UHDMeal *mealItem2 = [UHDMeal insertNewObjectIntoContext:managedObjectContext];
    mealItem2.remoteObjectId = -4;
    [dailyMenuItem2.mutableMeals addObject:mealItem2];
    mealItem2.title = @"[SAMPLE] Texashacksteak";
    mealItem2.price = @"1,70 €";
    mealItem2.section = sectionItem2;
    
    //THIRD
    //Create Mensa Object
    
    UHDMensa *mensaItem3 = [UHDMensa insertNewObjectIntoContext:managedObjectContext];
    mensaItem3.title = @"[SAMPLE] Triplex-Mensa";
    mensaItem3.image = [UIImage imageNamed:@"triplexmensa-01"];
    mensaItem3.location = [[CLLocation alloc] initWithLatitude:49.4107952 longitude:8.70567262];
    mensaItem3.remoteObjectId = -3;

    
    //Create Sections for Mensa
    
    UHDMensaSection *sectionItem3 = [UHDMensaSection insertNewObjectIntoContext:managedObjectContext];
    sectionItem3.title = @"[SAMPLE] Section C";
    sectionItem3.remoteObjectId = -2;
    [mensaItem3.mutableSections addObject:sectionItem3];
    
    //Create DailyMenu
    
    UHDDailyMenu *dailyMenuItem3 = [UHDDailyMenu insertNewObjectIntoContext:managedObjectContext];
    dailyMenuItem3.remoteObjectId = -3;
    dailyMenuItem3.date = [NSDate date];
    [mensaItem3.mutableMenus addObject:dailyMenuItem3];
    
    //Create Meal
    
    UHDMeal *mealItem3 = [UHDMeal insertNewObjectIntoContext:managedObjectContext];
    mealItem3.remoteObjectId = -5;
    [dailyMenuItem3.mutableMeals addObject:mealItem3];
    mealItem3.title = @"[SAMPLE] Spaghetti Bolognese";
    mealItem3.price = @"2,15 €";
    mealItem3.section = sectionItem3;

    
    [managedObjectContext saveToPersistentStore:NULL];
    */
}

@end
