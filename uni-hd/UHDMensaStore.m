//
//  UHDMensaStore.m
//  uni-hd
//
//  Created by Nils Fischer on 12.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDMensaStore.h"
#import "UHDMensa.h"
#import "UHDDailyMenu.h"
#import "UHDMeal.h"
#import "UHDLocation.h"
#import "UHDSection.h"



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
    //FIRST
    //Create Mensa Object
    
    UHDMensa *mensaItem = [UHDMensa insertNewObjectIntoContext:self.managedObjectContext];
    mensaItem.title = @"Marstall";
    
    //Create Location for Mensa
    
    UHDLocation *locationItem = [UHDLocation insertNewObjectIntoContext:self.managedObjectContext];
    locationItem.latitude = 49.41280; //Marstall coordinates
    locationItem.longitude = 8.70442;
    mensaItem.location = locationItem;
    
    //Create Sections for Mensa
    
    UHDSection *sectionItem = [UHDSection insertNewObjectIntoContext:self.managedObjectContext];
    sectionItem.title = @"Section A";
    [mensaItem.mutableSections addObject:sectionItem];
    
    //Create DailyMenu
    
    UHDDailyMenu *dailyMenuItem = [UHDDailyMenu insertNewObjectIntoContext:self.managedObjectContext];
    dailyMenuItem.date = [NSDate date];
    [mensaItem.mutableMenus addObject:dailyMenuItem];
    
    //Create Meal
    
    UHDMeal *mealItem = [UHDMeal insertNewObjectIntoContext:self.managedObjectContext];
    
    [dailyMenuItem.mutableMeals addObject:mealItem];
    mealItem.title = @"Chefsalat mit Ei";
    mealItem.price = @"2,15 €";
    
    //SECOND
    //Create Mensa Object
    
    UHDMensa *mensaItem2 = [UHDMensa insertNewObjectIntoContext:self.managedObjectContext];
    mensaItem2.title = @"Zentralmensa";
    
    //Create Location for Mensa
    
    UHDLocation *locationItem2 = [UHDLocation insertNewObjectIntoContext:self.managedObjectContext];
    locationItem2.latitude = 49.41280; //Marstall coordinates
    locationItem2.longitude = 8.70442;
    mensaItem2.location = locationItem2;
    
    //Create Sections for Mensa
    
    UHDSection *sectionItem2 = [UHDSection insertNewObjectIntoContext:self.managedObjectContext];
    sectionItem2.title = @"Section A";
    [mensaItem2.mutableSections addObject:sectionItem2];
    
    //Create DailyMenu
    
    UHDDailyMenu *dailyMenuItem2 = [UHDDailyMenu insertNewObjectIntoContext:self.managedObjectContext];
    dailyMenuItem2.date = [NSDate date];
    [mensaItem2.mutableMenus addObject:dailyMenuItem2];
    
    //Create Meal
    
    UHDMeal *mealItem2 = [UHDMeal insertNewObjectIntoContext:self.managedObjectContext];
    
    [dailyMenuItem2.mutableMeals addObject:mealItem2];
    mealItem2.title = @"Texashacksteak";
    mealItem2.price = @"1,70 €";
    [self.managedObjectContext save:NULL];
    
    //THIRD
    //Create Mensa Object
    
    UHDMensa *mensaItem3 = [UHDMensa insertNewObjectIntoContext:self.managedObjectContext];
    mensaItem3.title = @"Triplex-Mensa";
    
    //Create Location for Mensa
    
    UHDLocation *locationItem3 = [UHDLocation insertNewObjectIntoContext:self.managedObjectContext];
    locationItem3.latitude = 49.41280; //Marstall coordinates
    locationItem3.longitude = 8.70442;
    mensaItem3.location = locationItem3;
    
    //Create Sections for Mensa
    
    UHDSection *sectionItem3 = [UHDSection insertNewObjectIntoContext:self.managedObjectContext];
    sectionItem3.title = @"Section A";
    [mensaItem3.mutableSections addObject:sectionItem3];
    
    //Create DailyMenu
    
    UHDDailyMenu *dailyMenuItem3 = [UHDDailyMenu insertNewObjectIntoContext:self.managedObjectContext];
    dailyMenuItem3.date = [NSDate date];
    [mensaItem3.mutableMenus addObject:dailyMenuItem3];
    
    //Create Meal
    
    UHDMeal *mealItem3 = [UHDMeal insertNewObjectIntoContext:self.managedObjectContext];
    
    [dailyMenuItem3.mutableMeals addObject:mealItem3];
    mealItem3.title = @"Spaghetti Bolognese";
    mealItem3.price = @"2,15 €";
    [self.managedObjectContext save:NULL];
    
    
    

    
}

@end
