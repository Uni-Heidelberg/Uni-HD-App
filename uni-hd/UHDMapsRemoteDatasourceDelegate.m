//
//  UHDMapsRemoteDatasourceDelegate.m
//  uni-hd
//
//  Created by Andreas Schachner on 07.08.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDMapsRemoteDatasourceDelegate.h"

#import "UHDLocationCategory.h"
#import "UHDCampusRegion.h"
#import "UHDBuilding.h"


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
    // Create categories
    
    UHDLocationCategory *category1 = [UHDLocationCategory insertNewObjectIntoContext:managedObjectContext];
    category1.title = @"Fakultät für Physik und Astronomie";
    
    UHDLocationCategory *category2 = [UHDLocationCategory insertNewObjectIntoContext:managedObjectContext];
    category2.title = @"Fakultät für Mathematik und Informatik";
    
    UHDLocationCategory *category3 =[UHDLocationCategory insertNewObjectIntoContext:managedObjectContext];
    category3.title = @"Mensen";
    
    // Create campus regions
    
    UHDCampusRegion *inf = [UHDCampusRegion insertNewObjectIntoContext:managedObjectContext];
    inf.title = @"Im Neuenheimer Feld";
    inf.identifier = @"INF";
    
    
    //FIRST
    //Create Building Object
    
    UHDBuilding *buildingItem1 = [UHDBuilding insertNewObjectIntoContext:managedObjectContext];
    buildingItem1.title = @"Kirchhoff-Institut für Physik";
    buildingItem1.buildingNumber = @"227";
    buildingItem1.latitude = 49.416260; //INF 227 coordinates
    buildingItem1.longitude = 8.672190;
    buildingItem1.category = category1;
    buildingItem1.campusRegion = inf;
    buildingItem1.image = [UIImage imageNamed:@"kip"];
    
    
    /*
    //SECOND
    //Create Building Object
    UHDBuilding *buildingItem2 = [UHDBuilding insertNewObjectIntoContext:managedObjectContext];
    buildingItem2.title = @"INF 226";
    buildingItem2.subtitle = @"Klaus-Tschira-Gebäude";
    buildingItem2.latitude = 49.416250; //INF 226 coordinates
    buildingItem2.longitude = 8.673171;
    buildingItem2.category = category1;
    

    
    //THIRD
    //Create Building Object
    
    UHDBuilding *buildingItem3 = [UHDBuilding insertNewObjectIntoContext:managedObjectContext];
    buildingItem3.title = @"INF 308";
    buildingItem3.latitude = 49.417028; //INF 308 coordinates
    buildingItem3.longitude = 8.670807;
    buildingItem3.category = category1;
    
    
    
    //FOURTH
    //Create Building Object
    
    UHDBuilding *buildingItem4 = [UHDBuilding insertNewObjectIntoContext:managedObjectContext];
    buildingItem4.title = @"INF 288";
    buildingItem4.latitude = 49.417055; //INF 288 coordinates
    buildingItem4.longitude = 8.671665;
    buildingItem4.category = category2;
    
    
    
    
    //FIFTH
    //Create Building Object
    
    UHDBuilding *buildingItem5 = [UHDBuilding insertNewObjectIntoContext:managedObjectContext];
    buildingItem5.title = @"Marstall";
    buildingItem5.latitude = 49.41280; //Marstall coordinates
    buildingItem5.longitude = 8.70442;
    buildingItem5.imageName = @"marstallhof-01";
    buildingItem5.category = category3;
    
    */
    
    [managedObjectContext saveToPersistentStore:NULL];
}


@end
