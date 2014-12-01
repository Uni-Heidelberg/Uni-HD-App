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
    inf.location = [[CLLocation alloc] initWithLatitude:49.41763 longitude:8.666255];
    // Höhe
    inf.spanLatitude = 0.01416;
    // Breite
    inf.spanLongitude = 0.0222;
    /*
     Top Left: 49.424232, 8.655333
     Bottom Right: 49.410792, 8.676694
     Top Right: 49.424228, 8.676694
     */
    //inf.overlayImageURL = [NSURL URLWithString:@"https://dl.dropboxusercontent.com/s/40xqkz48pww7x9o/inf.png"];
    
    UHDCampusRegion *altstadt = [UHDCampusRegion insertNewObjectIntoContext:managedObjectContext];
    altstadt.title = @"Altstadt";
    altstadt.identifier = @"ALT";
    altstadt.location = [[CLLocation alloc] initWithLatitude:49.4114 longitude:8.707346];
    altstadt.spanLatitude = 0.008758;
    altstadt.spanLongitude = 0.029726;
    /*
     Punkt linke Seite: 49.409210, 8.692483
     Punkt oben: 49.415861, 8.712368
     */
    //altstadt.overlayImageURL = [NSURL URLWithString:@"https://dl.dropboxusercontent.com/s/ppavffrpx5uceis/alt.png"];
    
    UHDCampusRegion *bergheim = [UHDCampusRegion insertNewObjectIntoContext:managedObjectContext];
    bergheim.title = @"Bergheim";
    bergheim.identifier = @"BERG";
    bergheim.location = [[CLLocation alloc] initWithLatitude:49.4085 longitude:8.68685];
    bergheim.spanLatitude = 0.00315;
    bergheim.spanLongitude = 0.01095;
    //bergheim.overlayAngle = -0.268;
    //bergheim.overlayImageURL = [NSURL URLWithString:@"https://dl.dropboxusercontent.com/s/rycj0hzqntbx28j/berg.png"];
    
    /*
     Oben: 49.41150
     Unten: 49.40750
     rechts: 8.69300
     links: 8.68150
     Ursprünglich:
     bergheim.centerLatitude = 49.409425;
     bergheim.centerLongitude = 8.687439;
     bergheim.deltaLatitude = 0.004;
     bergheim.deltaLongitude = 0.0115;
     Angepasst:
     bergheim.centerLatitude = 49.4088;
     bergheim.centerLongitude = 8.6867;
    */
    
    
    
    //FIRST
    //Create Building Object
    
    UHDBuilding *buildingItem1 = [UHDBuilding insertNewObjectIntoContext:managedObjectContext];
    buildingItem1.title = @"Kirchhoff-Institut für Physik";
    buildingItem1.buildingNumber = @"227";
    buildingItem1.location = [[CLLocation alloc] initWithLatitude:49.416260 longitude:8.672190];
    buildingItem1.spanLatitude = 0.0005;
    buildingItem1.spanLongitude = 0.0009;
    buildingItem1.category = category1;
    buildingItem1.campusRegion = inf;
    buildingItem1.image = [UIImage imageNamed:@"kip1"];
    
    
    
    
    //SECOND
    //Create Building Object
    UHDBuilding *buildingItem2 = [UHDBuilding insertNewObjectIntoContext:managedObjectContext];
    buildingItem2.title =@"Physikalisches Institut (Klaus-Tschira-Gebäude)";
    buildingItem2.buildingNumber = @"226";
    buildingItem2.location = [[CLLocation alloc] initWithLatitude:49.416250 longitude:8.673171];
    buildingItem2.category = category1;
    buildingItem2.campusRegion = inf;
    buildingItem2.image = [UIImage imageNamed:@"kip"];
    

    
    //THIRD
    //Create Building Object
    
    UHDBuilding *buildingItem3 = [UHDBuilding insertNewObjectIntoContext:managedObjectContext];
    buildingItem3.title = @"INF 308";
    buildingItem3.buildingNumber = @"308";
    buildingItem3.location = [[CLLocation alloc] initWithLatitude:49.417028 longitude:8.670807];
    buildingItem3.category = category1;
    buildingItem3.campusRegion = inf;
    
    
    
    //FOURTH
    //Create Building Object
    
    UHDBuilding *buildingItem4 = [UHDBuilding insertNewObjectIntoContext:managedObjectContext];
    buildingItem4.title = @"INF 288";
    buildingItem4.buildingNumber = @"288";
    buildingItem4.location = [[CLLocation alloc] initWithLatitude:49.417055 longitude:8.671665];
    buildingItem4.category = category2;
    buildingItem4.campusRegion = inf;
    
    
    
    
    //FIFTH
    //Create Building Object
    
    UHDBuilding *buildingItem5 = [UHDBuilding insertNewObjectIntoContext:managedObjectContext];
    buildingItem5.title = @"Marstall";
    buildingItem5.buildingNumber = @"2010";
    buildingItem5.location = [[CLLocation alloc] initWithLatitude:49.41280 longitude:8.70442];
    buildingItem5.image = [UIImage imageNamed:@"marstallhof-01"];
    buildingItem5.category = category3;
    buildingItem5.campusRegion = altstadt;
    
    
    [managedObjectContext saveToPersistentStore:NULL];
}


/* not necessary anymore
- (UIImage *)overlayImageForUrl:(NSURL *)overlayImageURL
{
    UIImage *overlayImage = nil;
    
    // use in-project file
    // TODO: remove this option?
    if (!overlayImage) {
        overlayImage = [UIImage imageNamed:[overlayImageURL lastPathComponent]];
        if (overlayImage) [self.logger log:@"Using in-project overlay image file." object:overlayImageURL forLevel:VILogLevelDebug];
    }

    // use cached file
    NSString *cachedFile = [NSTemporaryDirectory() stringByAppendingPathComponent:overlayImageURL.lastPathComponent];
    if (!overlayImage) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:cachedFile]) {
            overlayImage = [UIImage imageWithContentsOfFile:cachedFile];
            [self.logger log:@"Cached overlay image file found." object:overlayImageURL forLevel:VILogLevelDebug];
        }
    }
    
    // download and cache
    // TODO: ignore multiple requests
    if (!overlayImage) {
        [self.logger log:@"Downloading overlay image..." object:overlayImageURL forLevel:VILogLevelDebug];
        NSData *imageData = [NSData dataWithContentsOfURL:overlayImageURL];
        if (imageData) {
            [imageData writeToFile:cachedFile atomically:YES];
            overlayImage = [UIImage imageWithData:imageData];
            [self.logger log:@"Done downloading overlay image and written to cache file." object:overlayImageURL forLevel:VILogLevelDebug];
        } else {
            [self.logger log:@"Could not download overlay image file." object:overlayImageURL forLevel:VILogLevelWarning];
        }
    }
    
    if (!overlayImage) {
        [self.logger log:@"Unable to retrieve overlay image." object:overlayImageURL forLevel:VILogLevelError];
    }
    
    return overlayImage;

} */

@end
