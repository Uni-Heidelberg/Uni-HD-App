//
//  UHDMapsRemoteDatasourceDelegate.m
//  uni-hd
//
//  Created by Andreas Schachner on 07.08.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDMapsRemoteDatasourceDelegate.h"
#import "UHDBuilding.h"
#import "UHDLocationCategory.h"


@implementation UHDMapsRemoteDatasourceDelegate

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
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[UHDBuilding entityName]];
    NSArray *allItems = [managedObjectContext executeFetchRequest:fetchRequest error:NULL];
    return allItems.count == 0;
}

- (void)remoteDatasource:(UHDRemoteDatasource *)remoteDatasource generateSampleDataForManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    //FIRST
    //Create Category
    
    UHDLocationCategory *category1 = [UHDLocationCategory insertNewObjectIntoContext:managedObjectContext];
    category1.title = @"Fakultät für Physik";
    
    UHDLocationCategory *category2 =[UHDLocationCategory insertNewObjectIntoContext:managedObjectContext];
    category2.title = @"Mensen";
    
    //FIRST
    //Create Building Object
    
    UHDBuilding *buildingItem1 = [UHDBuilding insertNewObjectIntoContext:managedObjectContext];
    buildingItem1.title = @"INF 227: Kirchhoff-Institut für Physik";
    buildingItem1.latitude = 49.416260; //INF 227 coordinates
    buildingItem1.longitude = 8.672190;
    //buildingItem1.image = [UIImage imageNamed:@"kip"];
    buildingItem1.category = category1;
    
    //[category1.mutableBuildings addObject:buildingItem1];
    
    
    //SECOND
    //Create Building Object
    //UHDBuilding *buildingItem2 = [UHDBuilding insertNewObjectIntoContext:managedObjectContext];
    //buildingItem2.title = @"INF 226: Klaus-Tschira-Gebäude";
    //buildingItem2.latitude = 49.416250; //INF 226 coordinates
    //buildingItem2.longitude = 8.673171;

    
    //THIRD
    //Create Building Object
    
    //UHDBuilding *buildingItem3 = [UHDBuilding insertNewObjectIntoContext:managedObjectContext];
    //buildingItem3.title = @"INF 308";
    //buildingItem3.latitude = 49.417028; //INF 308 coordinates
    //buildingItem3.longitude = 8.670807;
    
    
    //FOURTH
    //Create Building Object
    
    //UHDBuilding *buildingItem4 = [UHDBuilding insertNewObjectIntoContext:managedObjectContext];
    //buildingItem4.title = @"INF 288";
    //buildingItem4.latitude = 49.417055; //INF 288 coordinates
    //buildingItem4.longitude = 8.671665;
    
    
    //FIFTH
    //Create Building Object
    
    UHDBuilding *buildingItem5 = [UHDBuilding insertNewObjectIntoContext:managedObjectContext];
    buildingItem5.title = @"Marstall";
    buildingItem5.latitude = 49.41280; //Marstall coordinates
    buildingItem5.longitude = 8.70442;
    //buildingItem5.image = [UIImage imageNamed:@"marstallhof-01"];
    buildingItem5.category = category2;
    
    //[category2.mutableBuildings addObject:buildingItem5];
    

    [managedObjectContext saveToPersistentStore:NULL];
}


@end
