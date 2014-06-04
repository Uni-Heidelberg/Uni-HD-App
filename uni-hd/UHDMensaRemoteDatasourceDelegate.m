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
#import "UHDLocation.h"
#import "UHDMensaSection.h"


@implementation UHDMensaRemoteDatasourceDelegate

- (void)remoteDatasource:(UHDRemoteDatasource *)remoteDatasource setupObjectMappingForObjectManager:(RKObjectManager *)objectManager
{
    // TODO: setup object mapping
}

- (NSString *)remoteRefreshPathForRemoteDatasource:(UHDRemoteDatasource *)remoteDatasource
{
    return @"mensa";
}

- (NSArray *)remoteDatasource:(UHDRemoteDatasource *)remoteDatasource allItemsForManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[UHDMensa entityName]];
    NSError *error = nil;
    NSArray *allItems = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (error) {
        [self.logger log:@"Fetching all items" error:error];
    }
    return allItems;
}

- (void)remoteDatasource:(UHDRemoteDatasource *)remoteDatasource generateSampleDataForManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    //FIRST
    //Create Mensa Object
    
    UHDMensa *mensaItem = [UHDMensa insertNewObjectIntoContext:managedObjectContext];
    mensaItem.title = @"Marstall";
    mensaItem.remoteObjectId = 0;
    
    //Create Location for Mensa
    
    UHDLocation *locationItem = [UHDLocation insertNewObjectIntoContext:managedObjectContext];
    locationItem.latitude = 49.41280; //Marstall coordinates
    locationItem.longitude = 8.70442;
    mensaItem.location = locationItem;
    
    //Create Sections for Mensa
    
    UHDMensaSection *sectionItem = [UHDMensaSection insertNewObjectIntoContext:managedObjectContext];
    sectionItem.title = @"Section A";
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
    
	
    //SECOND
    //Create Mensa Object
    
    UHDMensa *mensaItem2 = [UHDMensa insertNewObjectIntoContext:managedObjectContext];
    mensaItem2.title = @"Zentralmensa";
    mensaItem2.remoteObjectId = 1;
    
    //Create Location for Mensa
    
    UHDLocation *locationItem2 = [UHDLocation insertNewObjectIntoContext:managedObjectContext];
    locationItem2.latitude = 49.41280; //Marstall coordinates
    locationItem2.longitude = 8.70442;
    mensaItem2.location = locationItem2;
    
    //Create Sections for Mensa
    
    UHDMensaSection *sectionItem2 = [UHDMensaSection insertNewObjectIntoContext:managedObjectContext];
    sectionItem2.title = @"Section A";
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

    
    //THIRD
    //Create Mensa Object
    
    UHDMensa *mensaItem3 = [UHDMensa insertNewObjectIntoContext:managedObjectContext];
    mensaItem3.title = @"Triplex-Mensa";
    mensaItem3.remoteObjectId = 2;
    
    //Create Location for Mensa
    
    UHDLocation *locationItem3 = [UHDLocation insertNewObjectIntoContext:managedObjectContext];
    locationItem3.latitude = 49.41280; //Marstall coordinates
    locationItem3.longitude = 8.70442;
    mensaItem3.location = locationItem3;
    
    //Create Sections for Mensa
    
    UHDMensaSection *sectionItem3 = [UHDMensaSection insertNewObjectIntoContext:managedObjectContext];
    sectionItem3.title = @"Section A";
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
    
    
    [managedObjectContext saveToPersistentStore:NULL];
    
}

@end
