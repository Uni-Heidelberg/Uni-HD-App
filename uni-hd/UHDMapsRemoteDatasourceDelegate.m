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
#import "UHDCampusRegionRenderer.h"


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
    inf.centerLatitude = 49.41763;
    inf.centerLongitude = 8.666255;
    // Höhe
    inf.deltaLatitude = 0.01416;
    // Breite
    inf.deltaLongitude = 0.0222;
    /*
     Top Left: 49.424232, 8.655333
     Bottom Right: 49.410792, 8.676694
     Top Right: 49.424228, 8.676694
     */
    
    UHDCampusRegion *altstadt = [UHDCampusRegion insertNewObjectIntoContext:managedObjectContext];
    altstadt.title = @"Altstadt";
    altstadt.identifier = @"Altstadt";
    altstadt.centerLatitude = 49.4114;
    altstadt.centerLongitude = 8.707346;
    altstadt.deltaLatitude = 0.008758;
    altstadt.deltaLongitude = 0.029726;
    /*
     Punkt linke Seite: 49.409210, 8.692483
     Punkt oben: 49.415861, 8.712368
     */
    
    UHDCampusRegion *bergheim = [UHDCampusRegion insertNewObjectIntoContext:managedObjectContext];
    bergheim.title = @"Bergheim";
    bergheim.identifier = @"Bergheim";
    bergheim.centerLatitude = 49.409425;
    bergheim.centerLongitude = 8.687439;
    bergheim.deltaLatitude = 0.004;
    bergheim.deltaLongitude = 0.0115;
    bergheim.overlayAngle = 0.1;
    
    /*
    Oben: 49.41150
    Unten: 49.40750
    rechts: 8.69300
    links: 8.68150
    */
    
    
    
    //FIRST
    //Create Building Object
    
    UHDBuilding *buildingItem1 = [UHDBuilding insertNewObjectIntoContext:managedObjectContext];
    buildingItem1.title = @"Kirchhoff-Institut für Physik";
    buildingItem1.buildingNumber = @"227";
    buildingItem1.latitude = 49.416260; //INF 227 coordinates
    buildingItem1.longitude = 8.672190;
    buildingItem1.category = category1;
    buildingItem1.campusRegion = inf;
    buildingItem1.image = [UIImage imageNamed:@"kip1"];
    
    
    
    
    //SECOND
    //Create Building Object
    UHDBuilding *buildingItem2 = [UHDBuilding insertNewObjectIntoContext:managedObjectContext];
    buildingItem2.title =@"Physikalisches Institut (Klaus-Tschira-Gebäude)";
    buildingItem2.buildingNumber = @"226";
    buildingItem2.latitude = 49.416250; //INF 226 coordinates
    buildingItem2.longitude = 8.673171;
    buildingItem2.category = category1;
    buildingItem2.campusRegion = inf;
    buildingItem2.image = [UIImage imageNamed:@"kip"];
    

    
    //THIRD
    //Create Building Object
    
    UHDBuilding *buildingItem3 = [UHDBuilding insertNewObjectIntoContext:managedObjectContext];
    buildingItem3.title = @"INF 308";
    buildingItem3.buildingNumber = @"308";
    buildingItem3.latitude = 49.417028; //INF 308 coordinates
    buildingItem3.longitude = 8.670807;
    buildingItem3.category = category1;
    buildingItem3.campusRegion = inf;
    
    
    
    //FOURTH
    //Create Building Object
    
    UHDBuilding *buildingItem4 = [UHDBuilding insertNewObjectIntoContext:managedObjectContext];
    buildingItem4.title = @"INF 288";
    buildingItem4.buildingNumber = @"288";
    buildingItem4.latitude = 49.417055; //INF 288 coordinates
    buildingItem4.longitude = 8.671665;
    buildingItem4.category = category2;
    buildingItem4.campusRegion = inf;
    
    
    
    
    //FIFTH
    //Create Building Object
    
    UHDBuilding *buildingItem5 = [UHDBuilding insertNewObjectIntoContext:managedObjectContext];
    buildingItem5.title = @"Marstall";
    buildingItem5.buildingNumber = @"";
    buildingItem5.latitude = 49.41280; //Marstall coordinates
    buildingItem5.longitude = 8.70442;
    buildingItem5.image = [UIImage imageNamed:@"marstallhof-01"];
    buildingItem5.category = category3;
    buildingItem5.campusRegion = altstadt;
    
    
    
    [managedObjectContext saveToPersistentStore:NULL];
}


@end
