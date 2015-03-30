//
//  UHDMapsRemoteDatasourceDelegate.m
//  uni-hd
//
//  Created by Andreas Schachner on 07.08.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDMapsRemoteDatasourceDelegate.h"
@import MapKit;
#import <RKCLLocationValueTransformer/RKCLLocationValueTransformer.h>
#import "NSManagedObject+VIInsertIntoContextCategory.h"
#import <UHDKit/UHDKit-Swift.h>

@implementation UHDMapsRemoteDatasourceDelegate

- (void)remoteDatasource:(UHDRemoteDatasource *)remoteDatasource setupObjectMappingForObjectManager:(RKObjectManager *)objectManager
{
   /*
    // Address
    
    RKEntityMapping *addressMapping = [RKEntityMapping mappingForEntityForName:[UHDAddress entityName] inManagedObjectStore:objectManager.managedObjectStore];
    [addressMapping addAttributeMappingsFromArray:@[ @"city", @"postalCode", @"street" ]];
    
    
    // Keywords
    
    RKEntityMapping *keywordsMapping = [RKEntityMapping mappingForEntityForName:@"UHDSearchKeyword" inManagedObjectStore:objectManager.managedObjectStore];
    [keywordsMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:nil toKeyPath:@"content"]];
    
    
    // Building
    
    RKEntityMapping *buildingMapping = [RKEntityMapping mappingForEntityForName:[Building entityName] inManagedObjectStore:objectManager.managedObjectStore];
    [buildingMapping addAttributeMappingsFromArray:@[ @"title", @"buildingNumber", @"email", @"telephone", @"spanLatitude", @"spanLongitude", @"url", @"campusRegionId", @"categoryId", @"associatedNewsSourceIds" ]];
    [buildingMapping addAttributeMappingsFromDictionary:@{ @"id": @"remoteObjectId", @"imageUrl": @"imageURL" }];
    RKAttributeMapping *locationMapping = [RKAttributeMapping attributeMappingFromKeyPath:@"location" toKeyPath:@"location"];
    locationMapping.valueTransformer = [RKCLLocationValueTransformer locationValueTransformerWithLatitudeKey:@"lat" longitudeKey:@"lng"];
    [buildingMapping addPropertyMapping:locationMapping];
    [buildingMapping addRelationshipMappingWithSourceKeyPath:@"address" mapping:addressMapping];
    [buildingMapping addRelationshipMappingWithSourceKeyPath:@"keywords" mapping:keywordsMapping];
    buildingMapping.identificationAttributes = @[ @"remoteObjectId" ];
    buildingMapping.identificationPredicate = [NSPredicate predicateWithFormat:@"entity == %@", buildingMapping.entity];
    RKConnectionDescription *buildingCampusRegionConnection = [[RKConnectionDescription alloc] initWithRelationship:[buildingMapping.entity relationshipsByName][@"campusRegion"] attributes:@{ @"campusRegionId": @"remoteObjectId" }];
    [buildingMapping addConnection:buildingCampusRegionConnection];
    RKConnectionDescription *buildingCategoryConnection = [[RKConnectionDescription alloc] initWithRelationship:[buildingMapping.entity relationshipsByName][@"category"] attributes:@{ @"categoryId": @"remoteObjectId" }];
    [buildingMapping addConnection:buildingCategoryConnection];
    RKConnectionDescription *buildingAssociatedNewsSourcesConnection = [[RKConnectionDescription alloc] initWithRelationship:[buildingMapping.entity relationshipsByName][@"associatedNewsSources"] attributes:@{ @"associatedNewsSourceIds": @"remoteObjectId" }];
    [buildingMapping addConnection:buildingAssociatedNewsSourcesConnection];
    [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:buildingMapping method:RKRequestMethodAny pathPattern:@"buildings" keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    // Stubs
    RKEntityMapping *buildingStubMapping = [RKEntityMapping mappingForEntityForName:[Building entityName] inManagedObjectStore:objectManager.managedObjectStore];
    [buildingStubMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:nil toKeyPath:@"remoteObjectId"]];
    buildingStubMapping.identificationAttributes = @[ @"remoteObjectId" ];
    buildingStubMapping.identificationPredicate = [NSPredicate predicateWithFormat:@"entity == %@", buildingStubMapping.entity];
    [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:buildingStubMapping method:RKRequestMethodAny pathPattern:nil keyPath:@"buildingId" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    
    // Category
    
    RKEntityMapping *categoryMapping = [RKEntityMapping mappingForEntityForName:[UHDLocationCategory entityName] inManagedObjectStore:objectManager.managedObjectStore];
    [categoryMapping addAttributeMappingsFromArray:@[ @"title" ]];
    [categoryMapping addAttributeMappingsFromDictionary:@{ @"id": @"remoteObjectId" }];
    categoryMapping.identificationAttributes = @[ @"remoteObjectId" ];
    categoryMapping.identificationPredicate = [NSPredicate predicateWithFormat:@"entity == %@", categoryMapping.entity];
    [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:categoryMapping method:RKRequestMethodAny pathPattern:@"categories" keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    // Stubs
    RKEntityMapping *categoryStubMapping = [RKEntityMapping mappingForEntityForName:[UHDLocationCategory entityName] inManagedObjectStore:objectManager.managedObjectStore];
    [categoryStubMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:nil toKeyPath:@"remoteObjectId"]];
    categoryStubMapping.identificationAttributes = @[ @"remoteObjectId" ];
    categoryStubMapping.identificationPredicate = [NSPredicate predicateWithFormat:@"entity == %@", categoryStubMapping.entity];
    [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:categoryStubMapping method:RKRequestMethodAny pathPattern:nil keyPath:@"categoryId" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    
    // Campus Region
    
    RKEntityMapping *campusRegionMapping = [RKEntityMapping mappingForEntityForName:[UHDCampusRegion entityName] inManagedObjectStore:objectManager.managedObjectStore];
    [campusRegionMapping addAttributeMappingsFromArray:@[ @"title", @"identifier", @"spanLatitude", @"spanLongitude", ]];
    [campusRegionMapping addAttributeMappingsFromDictionary:@{ @"id": @"remoteObjectId" }];
    [campusRegionMapping addPropertyMapping:[locationMapping copy]];
    campusRegionMapping.identificationAttributes = @[ @"remoteObjectId" ];
    campusRegionMapping.identificationPredicate = [NSPredicate predicateWithFormat:@"entity == %@", campusRegionMapping.entity];
    [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:campusRegionMapping method:RKRequestMethodAny pathPattern:@"campus-regions" keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    // Stubs
    RKEntityMapping *campusRegionStubMapping = [RKEntityMapping mappingForEntityForName:[UHDCampusRegion entityName] inManagedObjectStore:objectManager.managedObjectStore];
    [campusRegionStubMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:nil toKeyPath:@"remoteObjectId"]];
    campusRegionStubMapping.identificationAttributes = @[ @"remoteObjectId" ];
    campusRegionStubMapping.identificationPredicate = [NSPredicate predicateWithFormat:@"entity == %@", campusRegionStubMapping.entity];
    [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:campusRegionStubMapping method:RKRequestMethodAny pathPattern:nil keyPath:@"campusRegionId" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    */
}

- (NSArray *)remoteRefreshPathsForRemoteDatasource:(UHDRemoteDatasource *)remoteDatasource
{
    return nil;
}

- (BOOL)remoteDatasource:(UHDRemoteDatasource *)remoteDatasource shouldGenerateSampleDataForManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[Building entityName]];
    NSArray *allItems = [managedObjectContext executeFetchRequest:fetchRequest error:NULL];
    return allItems.count == 0;
}

- (void)remoteDatasource:(UHDRemoteDatasource *)remoteDatasource generateSampleDataForManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    NSBundle *imagesBundle = [NSBundle bundleForClass:[self class]];
    
    
    // Institutions
    
    Institution *fakPhys = [Institution insertNewObjectIntoContext:managedObjectContext];
    fakPhys.title = @"Fakultät für Physik und Astronomie";
    
    Institution *kip = [Institution insertNewObjectIntoContext:managedObjectContext];
    kip.title = @"Kirchhoff-Institut für Physik";
    kip.parent = fakPhys;
    kip.phone = @"06221549100";
    kip.email = @"info@kip.uni-heidelberg.de";
    kip.url = [NSURL URLWithString:@"http://www.kip.uni-heidelberg.de"];
    
    
    Institution *stw = [Institution insertNewObjectIntoContext:managedObjectContext];
    stw.title = @"Studentenwerk";

    
    // Campus regions
    
    CampusRegion *inf = [CampusRegion insertNewObjectIntoContext:managedObjectContext];
    inf.title = @"Im Neuenheimer Feld";
    inf.identifier = @"INF";
    //inf.location = [[CLLocation alloc] initWithLatitude:49.41763 longitude:8.666255];
    // Höhe
    //inf.spanLatitude = 0.01416;
    // Breite
    //inf.spanLongitude = 0.0222;
    /*
     Top Left: 49.424232, 8.655333
     Bottom Right: 49.410792, 8.676694
     Top Right: 49.424228, 8.676694
     */
    //inf.overlayImageURL = [NSURL URLWithString:@"https://dl.dropboxusercontent.com/s/40xqkz48pww7x9o/inf.png"];
    
    CampusRegion *altstadt = [CampusRegion insertNewObjectIntoContext:managedObjectContext];
    altstadt.title = @"Altstadt";
    altstadt.identifier = @"ALT";
    /*altstadt.location = [[CLLocation alloc] initWithLatitude:49.4114 longitude:8.707346];
    altstadt.spanLatitude = 0.008758;
    altstadt.spanLongitude = 0.029726;*/
    /*
     Punkt linke Seite: 49.409210, 8.692483
     Punkt oben: 49.415861, 8.712368
     */
    //altstadt.overlayImageURL = [NSURL URLWithString:@"https://dl.dropboxusercontent.com/s/ppavffrpx5uceis/alt.png"];
    
    /*UHDCampusRegion *bergheim = [UHDCampusRegion insertNewObjectIntoContext:managedObjectContext];
    bergheim.title = @"Bergheim";
    bergheim.identifier = @"BERG";
    bergheim.location = [[CLLocation alloc] initWithLatitude:49.4085 longitude:8.68685];
    bergheim.spanLatitude = 0.00315;
    bergheim.spanLongitude = 0.01095;*/
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
    
    CampusRegion *phw = [CampusRegion insertNewObjectIntoContext:managedObjectContext];
    phw.title = @"Philosophenweg";
    phw.identifier = @"PHW";
    //phw.location = [[CLLocation alloc] initWithLatitude:49.414807 longitude:8.696407];
    //phw.spanLatitude = 0.002;
    //phw.spanLongitude = 0.004;*/
    
    
    // Buildings
    
    Building *inf227 = [Building insertNewObjectIntoContext:managedObjectContext];
    inf227.number = @"227";
    inf227.nodes = [[NSOrderedSet alloc] initWithObjects:
                    [Node insertNewObjectWithCoordinate:CLLocationCoordinate2DMake(49.4165764, 8.6716101) intoManagedObjectContext:managedObjectContext],
                    [Node insertNewObjectWithCoordinate:CLLocationCoordinate2DMake(49.4165759, 8.6725096) intoManagedObjectContext:managedObjectContext],
                    [Node insertNewObjectWithCoordinate:CLLocationCoordinate2DMake(49.4160892, 8.672509) intoManagedObjectContext:managedObjectContext],
                    [Node insertNewObjectWithCoordinate:CLLocationCoordinate2DMake(49.4160897, 8.6716095) intoManagedObjectContext:managedObjectContext], nil];
    inf227.campusRegion = inf;
    inf227.image = [UIImage imageNamed:@"kip1" inBundle:imagesBundle compatibleWithTraitCollection:nil];
    /*NSManagedObject *kipKeyword = [NSEntityDescription insertNewObjectForEntityForName:@"UHDSearchKeyword" inManagedObjectContext:managedObjectContext];
    [kipKeyword setValue:@"KIP" forKey:@"content"];
    inf227.keywords = [NSSet setWithObject:kipKeyword];*/

    kip.location = inf227;

    /*Building *inf226 = [Building insertNewObjectIntoContext:managedObjectContext];
    inf226.title =@"Klaus-Tschira-Gebäude";
    //(Physikalisches Institut)
    inf226.buildingNumber = @"226";
    inf226.spanLatitude = 0.000518;
    inf226.spanLongitude = 0.000848;
    inf226.location = [[CLLocation alloc] initWithLatitude:49.416250 longitude:8.673171];
    inf226.category = fakPhys;
    inf226.campusRegion = inf;
    inf226.image = [UIImage imageNamed:@"kip" inBundle:imagesBundle compatibleWithTraitCollection:nil];
    UHDAddress *inf226Address = [UHDAddress insertNewObjectIntoContext:managedObjectContext];
    inf226Address.street = @"Im Neuenheimer Feld 226";
    inf226Address.postalCode = @"69120";
    inf226Address.city = @"Heidelberg";
    inf226.address = inf226Address;
    inf226.url = [NSURL URLWithString:@"http://www.physi.uni-heidelberg.de"];
    inf226.telephone = @"062215419600";
    inf226.email = @"info@physi.uni-heidelberg.de";
    NSManagedObject *piKeyword = [NSEntityDescription insertNewObjectForEntityForName:@"UHDSearchKeyword" inManagedObjectContext:managedObjectContext];
    [piKeyword setValue:@"PI" forKey:@"content"];
    NSManagedObject *piKeyword2 = [NSEntityDescription insertNewObjectForEntityForName:@"UHDSearchKeyword" inManagedObjectContext:managedObjectContext];
    [piKeyword2 setValue:@"Physikalisches Institut" forKey:@"content"];
    inf226.keywords = [NSSet setWithObjects:piKeyword, piKeyword2, nil];
    //links 49.416267, 8.672747
    //oben 49.416509, 8.673171
    */
    
    Building *inf308 = [Building insertNewObjectIntoContext:managedObjectContext];
    inf308.number = @"308";
    //inf308.spanLatitude = 0.0006;
    //inf308.spanLongitude = 0.001;
    //inf308.location = [[CLLocation alloc] initWithLatitude:49.417515 longitude:8.670593];
    inf308.image = [UIImage imageNamed:@"INF308" inBundle:imagesBundle compatibleWithTraitCollection:nil];
    inf308.campusRegion = inf;
    /*UHDAddress *inf308Address = [UHDAddress insertNewObjectIntoContext:managedObjectContext];
    inf308Address.street = @"Im Neuenheimer Feld 308";
    inf308Address.postalCode = @"69120";
    inf308Address.city = @"Heidelberg";
    inf308.address = inf308Address;
    //oben 49.417816, 8.670585
    //rechts 49.417468, 8.671014
    */
    
    Building *inf304 = [Building insertNewObjectIntoContext:managedObjectContext];
    inf304.number = @"304";
    inf304.campusRegion = inf;
    Building *alt2010 = [Building insertNewObjectIntoContext:managedObjectContext];
    alt2010.number = @"2010";
    alt2010.campusRegion = altstadt;
    Building *alt2100 = [Building insertNewObjectIntoContext:managedObjectContext];
    alt2100.number = @"2100";
    alt2100.campusRegion = altstadt;
    /*Building *inf228 = [Building insertNewObjectIntoContext:managedObjectContext];
    inf228.title = @"Mathematisches Institut";
    inf228.spanLatitude = 0.0006;
    inf228.spanLongitude = 0.0007;
    inf228.buildingNumber = @"288";
    inf228.location = [[CLLocation alloc] initWithLatitude:49.417055 longitude:8.671665];
    inf228.image = [UIImage imageNamed:@"INF288" inBundle:imagesBundle compatibleWithTraitCollection:nil];
    inf228.category = fakMath;
    inf228.campusRegion = inf;
    UHDAddress *inf228Address = [UHDAddress insertNewObjectIntoContext:managedObjectContext];
    inf228Address.street = @"Im Neuenheimer Feld 288";
    inf228Address.postalCode = @"69120";
    inf228Address.city = @"Heidelberg";
    inf228.address = inf228Address;
    inf228.url = [NSURL URLWithString:@"https://www.mathinf.uni-heidelberg.de"];
    inf228.telephone = @"06221545758";
    inf228.email = @"dekanat@mathi.uni-heidelberg.de";
    //oben 49.417387, 8.671622
    //rechts 49.417079, 8.672006
     
    
    Building *phw12 = [Building insertNewObjectIntoContext:managedObjectContext];
    phw12.buildingNumber = @"8010";
    phw12.title = @"Physikalisches Institut";
    phw12.spanLatitude = 0.0006;
    phw12.spanLongitude = 0.00075;
    phw12.location = [[CLLocation alloc] initWithLatitude:49.414781 longitude:8.695585];
    phw12.image = [UIImage imageNamed:@"PI_PHW12" inBundle:imagesBundle compatibleWithTraitCollection:nil];
    phw12.category = fakPhys;
    phw12.campusRegion = phw;
    UHDAddress *phw12Address = [UHDAddress insertNewObjectIntoContext:managedObjectContext];
    phw12Address.street = @"Philosophenweg 12";
    phw12Address.postalCode = @"69120";
    phw12Address.city = @"Heidelberg";
    phw12.address = phw12Address;
    //oben 49.415161, 8.695507
    //unten 49.414549, 8.695512
    //links 49.414764, 8.694992
    //rechts 49.414769, 8.695764

    Building *phw16 = [Building insertNewObjectIntoContext:managedObjectContext];
    phw16.buildingNumber = @"8050";
    phw16.title = @"Institut für Theoretische Physik";
    phw16.spanLatitude = 0.0002;
    phw16.spanLongitude = 0.0005;
    phw16.location = [[CLLocation alloc] initWithLatitude:49.414811 longitude:8.696707];
    phw16.image = [UIImage imageNamed:@"TI_PHW16" inBundle:imagesBundle compatibleWithTraitCollection:nil];
    phw16.category = fakPhys;
    phw16.campusRegion = phw;
    UHDAddress *phw16Address = [UHDAddress insertNewObjectIntoContext:managedObjectContext];
    phw16Address.street = @"Philosophenweg 16";
    phw16Address.postalCode = @"69120";
    phw16Address.city = @"Heidelberg";
    phw16.address = phw16Address;
    phw16.url = [NSURL URLWithString:@"http://www.thphys.uni-heidelberg.de"];
    phw16.telephone = @"06221549444";
    phw16.email = @"Sekretariat16@thphys.uni-heidelberg.de";
    //links 49.414820, 8.696450
    //rechts 49.414776, 8.696944
    //oben 49.414968, 8.696712
    */
    Building *phw19 = [Building insertNewObjectIntoContext:managedObjectContext];
    phw19.number = @"8080";
    /*phw19.spanLatitude = 0.0002;
    phw19.spanLongitude = 0.0005;
    phw19.location = [[CLLocation alloc] initWithLatitude:49.415058 longitude:8.698714];*/
    phw19.image = [UIImage imageNamed:@"TI_PHW19" inBundle:imagesBundle compatibleWithTraitCollection:nil];
    phw19.campusRegion = phw;
/*    UHDAddress *phw19Address = [UHDAddress insertNewObjectIntoContext:managedObjectContext];
    phw19Address.street = @"Philosophenweg 19";
    phw19Address.postalCode = @"69120";
    phw19Address.city = @"Heidelberg";
    phw19.address = phw19Address;
    phw19.url = [NSURL URLWithString:@"http://www.thphys.uni-heidelberg.de"];
    phw19.telephone = @"06221549431";
    phw19.email = @"Sekretariat19@thphys.uni-heidelberg.de";*/

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
