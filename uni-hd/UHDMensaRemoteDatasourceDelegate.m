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


@implementation UHDMensaRemoteDatasourceDelegate

- (void)remoteDatasource:(UHDRemoteDatasource *)remoteDatasource setupObjectMappingForObjectManager:(RKObjectManager *)objectManager
{
    // TODO: setup object mapping
}

- (NSArray *)remoteRefreshPathsForRemoteDatasource:(UHDRemoteDatasource *)remoteDatasource
{
    return nil;
}

- (BOOL)remoteDatasource:(UHDRemoteDatasource *)remoteDatasource shouldGenerateSampleDataForManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[UHDMensa entityName]];
    NSArray *allItems = [managedObjectContext executeFetchRequest:fetchRequest error:NULL];
    return allItems.count == 0;
}

- (void)remoteDatasource:(UHDRemoteDatasource *)remoteDatasource generateSampleDataForManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    //FIRST
    //Create Mensa Object
    
    UHDMensa *mensaItem = [UHDMensa insertNewObjectIntoContext:managedObjectContext];
    mensaItem.title = @"Marstall";
    mensaItem.image = [UIImage imageNamed:@"marstallhof-01"];
    mensaItem.location = [[CLLocation alloc] initWithLatitude:49.41297656 longitude:8.70445222];
    mensaItem.remoteObjectId = 0;
    
    
    //Create Sections for Mensa
    
    UHDMensaSection *sectionItem = [UHDMensaSection insertNewObjectIntoContext:managedObjectContext];
    sectionItem.title = @"Section A";
    sectionItem.remoteObjectId = 0;
    
    UHDMensaSection *sectionItem2 = [UHDMensaSection insertNewObjectIntoContext:managedObjectContext];
    sectionItem2.title = @"Section B";
    sectionItem.remoteObjectId = 1;

    
    [mensaItem.mutableSections addObject:sectionItem];
    
    //Create DailyMenu
    
    UHDDailyMenu *dailyMenuItem = [UHDDailyMenu insertNewObjectIntoContext:managedObjectContext];
    dailyMenuItem.date = [NSDate date];
    [mensaItem.mutableMenus addObject:dailyMenuItem];
    
    //Create Meal
    
    UHDMeal *mealItem = [UHDMeal insertNewObjectIntoContext:managedObjectContext];
    
    [dailyMenuItem.mutableMeals addObject:mealItem];
    mealItem.title = @"Chefsalat mit Ei";
    mealItem.price = @"2,15 €";
    mealItem.section = sectionItem;
    
    UHDMeal *mealItem4 = [UHDMeal insertNewObjectIntoContext:managedObjectContext];
    
    [dailyMenuItem.mutableMeals addObject:mealItem4];
    mealItem4.title = @"Chefsalat mit Ei und Käse";
    mealItem4.price = @"2,15 €";
    mealItem4.section = sectionItem2;
	
    UHDMeal *mealItem5 = [UHDMeal insertNewObjectIntoContext:managedObjectContext];
    
    [dailyMenuItem.mutableMeals addObject:mealItem5];
    mealItem5.title = @"Chefsalat mit Ei und Käse und Soße";
    mealItem5.price = @"2,15 €";
    mealItem5.section = sectionItem;
    
    //SECOND
    //Create Mensa Object
    
    UHDMensa *mensaItem2 = [UHDMensa insertNewObjectIntoContext:managedObjectContext];
    mensaItem2.title = @"Zentralmensa";
    mensaItem2.image = [UIImage imageNamed:@"zentralmensa-01"];
    mensaItem2.location = [[CLLocation alloc] initWithLatitude:49.41555917 longitude:8.67088169];
    mensaItem2.remoteObjectId = 1;

    
    //Create Sections for Mensa
    
//    UHDMensaSection *sectionItem2 = [UHDMensaSection insertNewObjectIntoContext:managedObjectContext];
//    sectionItem2.title = @"Section B";
    [mensaItem2.mutableSections addObject:sectionItem2];
    
    //Create DailyMenu
    
    UHDDailyMenu *dailyMenuItem2 = [UHDDailyMenu insertNewObjectIntoContext:managedObjectContext];
    dailyMenuItem2.date = [NSDate date];
    [mensaItem2.mutableMenus addObject:dailyMenuItem2];
    
    //Create Meal
    
    UHDMeal *mealItem2 = [UHDMeal insertNewObjectIntoContext:managedObjectContext];
    
    [dailyMenuItem2.mutableMeals addObject:mealItem2];
    mealItem2.title = @"Texashacksteak";
    mealItem2.price = @"1,70 €";
    mealItem2.section = sectionItem2;
    
    //THIRD
    //Create Mensa Object
    
    UHDMensa *mensaItem3 = [UHDMensa insertNewObjectIntoContext:managedObjectContext];
    mensaItem3.title = @"Triplex-Mensa";
    mensaItem3.image = [UIImage imageNamed:@"triplexmensa-01"];
    mensaItem3.location = [[CLLocation alloc] initWithLatitude:49.4107952 longitude:8.70567262];
    mensaItem3.remoteObjectId = 2;

    
    //Create Sections for Mensa
    
    UHDMensaSection *sectionItem3 = [UHDMensaSection insertNewObjectIntoContext:managedObjectContext];
    sectionItem3.title = @"Section C";
    sectionItem3.remoteObjectId = 2;
    [mensaItem3.mutableSections addObject:sectionItem3];
    
    //Create DailyMenu
    
    UHDDailyMenu *dailyMenuItem3 = [UHDDailyMenu insertNewObjectIntoContext:managedObjectContext];
    dailyMenuItem3.date = [NSDate date];
    [mensaItem3.mutableMenus addObject:dailyMenuItem3];
    
    //Create Meal
    
    UHDMeal *mealItem3 = [UHDMeal insertNewObjectIntoContext:managedObjectContext];
    
    [dailyMenuItem3.mutableMeals addObject:mealItem3];
    mealItem3.title = @"Spaghetti Bolognese";
    mealItem3.price = @"2,15 €";
    mealItem3.section = sectionItem3;

    
    [managedObjectContext saveToPersistentStore:NULL];
    
}

@end
