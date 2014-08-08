//
//  UHDMapsRemoteDatasourceDelegate.m
//  uni-hd
//
//  Created by Andreas Schachner on 07.08.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDMapsRemoteDatasourceDelegate.h"
#import "UHDBuilding.h"
#import "UHDLocationPoints.h"


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
    //Create Building Object
    
    UHDBuilding *buildingItem = [UHDBuilding insertNewObjectIntoContext:managedObjectContext];
    buildingItem.title = @"INF 227";
    buildingItem.remoteObjectId = 0;
    
    //Create Location for Building
    
    UHDLocationPoints *locationItem = [UHDLocationPoints insertNewObjectIntoContext:managedObjectContext];
    locationItem.latitude = 49.416816; //INF 227 coordinates
    locationItem.longitude = 8.673392;
    buildingItem.location = locationItem;
    
    
    
    //SECOND
    //Create Building Object
    
    UHDBuilding *buildingItem2 = [UHDBuilding insertNewObjectIntoContext:managedObjectContext];
    buildingItem2.title = @"INF 226";
    buildingItem2.remoteObjectId = 0;
    
    //Create Location for Building
    
    UHDLocationPoints *locationItem2 = [UHDLocationPoints insertNewObjectIntoContext:managedObjectContext];
    locationItem2.latitude = 49.416812; //INF 226 coordinates
    locationItem2.longitude = 8.674451;
    buildingItem2.location = locationItem2;
    
  
    
    //THIRD
    //Create Building Object
    
    UHDBuilding *buildingItem3 = [UHDBuilding insertNewObjectIntoContext:managedObjectContext];
    buildingItem3.title = @"INF 308";
    buildingItem3.remoteObjectId = 0;
    
    //Create Location for Building
    
    UHDLocationPoints *locationItem3 = [UHDLocationPoints insertNewObjectIntoContext:managedObjectContext];
    locationItem3.latitude = 49.417028; //INF 308 coordinates
    locationItem3.longitude = 8.670807;
    buildingItem3.location = locationItem3;
    
    //FOURTH
    //Create Building Object
    
    UHDBuilding *buildingItem4 = [UHDBuilding insertNewObjectIntoContext:managedObjectContext];
    buildingItem4.title = @"INF 288";
    buildingItem4.remoteObjectId = 0;
    
    //Create Location for Building
    
    UHDLocationPoints *locationItem4 = [UHDLocationPoints insertNewObjectIntoContext:managedObjectContext];
    locationItem4.latitude = 49.417055; //INF 288 coordinates
    locationItem4.longitude = 8.671665;
    buildingItem4.location = locationItem4;
    
    [managedObjectContext saveToPersistentStore:NULL];
    
    //FIFTH
    //Create Building Object
    
    UHDBuilding *buildingItem5 = [UHDBuilding insertNewObjectIntoContext:managedObjectContext];
    buildingItem5.title = @"Marstall";
    buildingItem5.remoteObjectId = 0;
    
    //Create Location for Building
    
    UHDLocationPoints *locationItem5 = [UHDLocationPoints insertNewObjectIntoContext:managedObjectContext];
    locationItem5.latitude = 49.41280; //Marstall coordinates
    locationItem5.longitude = 8.70442;
    buildingItem5.location = locationItem5;
    
    
    
    
    
    
    [managedObjectContext saveToPersistentStore:NULL];
    
    
}


@end
