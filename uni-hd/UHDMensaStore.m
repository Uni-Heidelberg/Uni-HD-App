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
    [self.managedObjectContext save:NULL];

    
}

@end
