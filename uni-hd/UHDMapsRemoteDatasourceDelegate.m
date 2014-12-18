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
#import "UHDAddress.h"


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
    
    UHDCampusRegion *phw = [UHDCampusRegion insertNewObjectIntoContext:managedObjectContext];
    phw.title = @"Philosophenweg";
    phw.identifier = @"PHW";
    phw.location = [[CLLocation alloc] initWithLatitude:49.414807 longitude:8.696407];
    phw.spanLatitude = 0.002;
    phw.spanLongitude = 0.004;
    
    
    
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
    UHDAddress *address1 = [UHDAddress insertNewObjectIntoContext:managedObjectContext];
    address1.street = @"Im Neuenheimer Feld 227";
    address1.postalCode = @"69120";
    address1.city = @"Heidelberg";
    buildingItem1.address = address1;
    buildingItem1.url = [NSURL URLWithString:@"http://www.kip.uni-heidelberg.de"];
    buildingItem1.telephone = @"06221549100";
    buildingItem1.email = @"info@kip.uni-heidelberg.de";
    NSManagedObject *kipKeyword = [NSEntityDescription insertNewObjectForEntityForName:@"UHDSearchKeyword" inManagedObjectContext:managedObjectContext];
    [kipKeyword setValue:@"KIP" forKey:@"content"];
    buildingItem1.keywords = [NSSet setWithObject:kipKeyword];
    
    
    
    
    //SECOND
    //Create Building Object
    UHDBuilding *buildingItem2 = [UHDBuilding insertNewObjectIntoContext:managedObjectContext];
    buildingItem2.title =@"Klaus-Tschira-Gebäude";
    //(Physikalisches Institut)
    buildingItem2.buildingNumber = @"226";
    buildingItem2.spanLatitude = 0.000518;
    buildingItem2.spanLongitude = 0.000848;
    buildingItem2.location = [[CLLocation alloc] initWithLatitude:49.416250 longitude:8.673171];
    buildingItem2.category = category1;
    buildingItem2.campusRegion = inf;
    buildingItem2.image = [UIImage imageNamed:@"kip"];
    UHDAddress *address2 = [UHDAddress insertNewObjectIntoContext:managedObjectContext];
    address2.street = @"Im Neuenheimer Feld 226";
    address2.postalCode = @"69120";
    address2.city = @"Heidelberg";
    buildingItem2.address = address2;
    buildingItem2.url = [NSURL URLWithString:@"http://www.physi.uni-heidelberg.de"];
    buildingItem2.telephone = @"062215419600";
    buildingItem2.email = @"info@physi.uni-heidelberg.de";
    NSManagedObject *piKeyword = [NSEntityDescription insertNewObjectForEntityForName:@"UHDSearchKeyword" inManagedObjectContext:managedObjectContext];
    [piKeyword setValue:@"PI" forKey:@"content"];
    NSManagedObject *piKeyword2 = [NSEntityDescription insertNewObjectForEntityForName:@"UHDSearchKeyword" inManagedObjectContext:managedObjectContext];
    [piKeyword2 setValue:@"Physikalisches Institut" forKey:@"content"];
    buildingItem2.keywords = [NSSet setWithObjects:piKeyword, piKeyword2, nil];

    //links 49.416267, 8.672747
    //oben 49.416509, 8.673171
    


    //THIRD
    //Create Building Object
    
    UHDBuilding *buildingItem3 = [UHDBuilding insertNewObjectIntoContext:managedObjectContext];
    buildingItem3.buildingNumber = @"308";
    buildingItem3.spanLatitude = 0.0006;
    buildingItem3.spanLongitude = 0.001;
    buildingItem3.location = [[CLLocation alloc] initWithLatitude:49.417515 longitude:8.670593];
    buildingItem3.image = [UIImage imageNamed:@"INF308"];
    buildingItem3.category = category1;
    buildingItem3.campusRegion = inf;
    UHDAddress *address3 = [UHDAddress insertNewObjectIntoContext:managedObjectContext];
    address3.street = @"Im Neuenheimer Feld 308";
    address3.postalCode = @"69120";
    address3.city = @"Heidelberg";
    buildingItem3.address = address3;
    
    //oben 49.417816, 8.670585
    //rechts 49.417468, 8.671014
    
    
    
    
    //FOURTH
    //Create Building Object
    
    UHDBuilding *buildingItem4 = [UHDBuilding insertNewObjectIntoContext:managedObjectContext];
    buildingItem4.title = @"Mathematisches Institut";
    buildingItem4.spanLatitude = 0.0006;
    buildingItem4.spanLongitude = 0.0007;
    buildingItem4.buildingNumber = @"288";
    buildingItem4.location = [[CLLocation alloc] initWithLatitude:49.417055 longitude:8.671665];
    buildingItem4.image = [UIImage imageNamed:@"INF288"];
    buildingItem4.category = category2;
    buildingItem4.campusRegion = inf;
    UHDAddress *address4 = [UHDAddress insertNewObjectIntoContext:managedObjectContext];
    address4.street = @"Im Neuenheimer Feld 288";
    address4.postalCode = @"69120";
    address4.city = @"Heidelberg";
    buildingItem4.address = address4;
    buildingItem4.url = [NSURL URLWithString:@"https://www.mathinf.uni-heidelberg.de"];
    buildingItem4.telephone = @"06221545758";
    buildingItem4.email = @"dekanat@mathi.uni-heidelberg.de";
    
    //oben 49.417387, 8.671622
    //rechts 49.417079, 8.672006
    
    //FIFTH
    //Create Building Object
    
    UHDBuilding *buildingItem5 = [UHDBuilding insertNewObjectIntoContext:managedObjectContext];
    buildingItem5.buildingNumber = @"8010";
    buildingItem5.title = @"Physikalisches Institut";
    buildingItem5.spanLatitude = 0.0006;
    buildingItem5.spanLongitude = 0.00075;
    buildingItem5.location = [[CLLocation alloc] initWithLatitude:49.414781 longitude:8.695585];
    buildingItem5.image = [UIImage imageNamed:@"PI_PHW12"];
    buildingItem5.category = category1;
    buildingItem5.campusRegion = phw;
    UHDAddress *address5 = [UHDAddress insertNewObjectIntoContext:managedObjectContext];
    address5.street = @"Philosophenweg 12";
    address5.postalCode = @"69120";
    address5.city = @"Heidelberg";
    buildingItem5.address = address5;
    
    //oben 49.415161, 8.695507
    //unten 49.414549, 8.695512
    //links 49.414764, 8.694992
    //rechts 49.414769, 8.695764
    
    //SIXTH
    //Create Building Object
    
    UHDBuilding *buildingItem6 = [UHDBuilding insertNewObjectIntoContext:managedObjectContext];
    buildingItem6.buildingNumber = @"8050";
    buildingItem6.title = @"Institut für Theoretische Physik";
    buildingItem6.spanLatitude = 0.0002;
    buildingItem6.spanLongitude = 0.0005;
    buildingItem6.location = [[CLLocation alloc] initWithLatitude:49.414811 longitude:8.696707];
    buildingItem6.image = [UIImage imageNamed:@"TI_PHW16"];
    buildingItem6.category = category1;
    buildingItem6.campusRegion = phw;
    UHDAddress *address6 = [UHDAddress insertNewObjectIntoContext:managedObjectContext];
    address6.street = @"Philosophenweg 16";
    address6.postalCode = @"69120";
    address6.city = @"Heidelberg";
    buildingItem6.address = address6;
    buildingItem6.url = [NSURL URLWithString:@"http://www.thphys.uni-heidelberg.de"];
    buildingItem6.telephone = @"06221549444";
    buildingItem6.email = @"Sekretariat16@thphys.uni-heidelberg.de";
    
    //links 49.414820, 8.696450
    //rechts 49.414776, 8.696944
    //oben 49.414968, 8.696712
    
    //Create Building Object 7
    
    UHDBuilding *buildingItem7 = [UHDBuilding insertNewObjectIntoContext:managedObjectContext];
    buildingItem7.buildingNumber = @"8080";
    buildingItem7.title = @"Institut für Theoretische Physik";
    buildingItem7.spanLatitude = 0.0002;
    buildingItem7.spanLongitude = 0.0005;
    buildingItem7.location = [[CLLocation alloc] initWithLatitude:49.415058 longitude:8.698714];
    buildingItem7.image = [UIImage imageNamed:@"TI_PHW19"];
    buildingItem7.category = category1;
    buildingItem7.campusRegion = phw;
    UHDAddress *address7 = [UHDAddress insertNewObjectIntoContext:managedObjectContext];
    address7.street = @"Philosophenweg 19";
    address7.postalCode = @"69120";
    address7.city = @"Heidelberg";
    buildingItem7.address = address7;
    buildingItem7.url = [NSURL URLWithString:@"http://www.thphys.uni-heidelberg.de"];
    buildingItem7.telephone = @"06221549431";
    buildingItem7.email = @"Sekretariat19@thphys.uni-heidelberg.de";
    
    

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
