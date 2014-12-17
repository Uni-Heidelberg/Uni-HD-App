//
//  UHDAppDelegate.m
//  uni-hd
//
//  Created by Nils Fischer on 24.04.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDAppDelegate.h"

// Persistent Stack
#import "UHDPersistentStack.h"

// Remote Datasources
#import "UHDRemoteDatasourceManager.h"
#import "UHDRemoteDatasource.h"
#import "UHDNewsRemoteDatasourceDelegate.h"
#import "UHDMensaRemoteDatasourceDelegate.h"
#import "UHDMapsRemoteDatasourceDelegate.h"

// View Controllers
#import "UHDNewsViewController.h"
#import "UHDMensaViewController.h"
#import "UHDMapsViewController.h"

// Logging Config
#import "VIFetchedResultsControllerDataSource.h"


// tmp
#import "UHDDailyMenu.h"
#import "UHDMeal.h"
#import "UHDMensa.h"
#import "UHDBuilding.h"
#import "UHDLocationCategory.h"
#import "UHDCampusRegion.h"
#import "UHDAddress.h"
#import "UHDEventItem.h"


@interface UHDAppDelegate ()

@property (strong, nonatomic) UHDPersistentStack *persistentStack;
@property (strong, nonatomic) NSMutableArray *remoteDatasourceDelegates;

- (void)addRemoteDatasourceForKey:(NSString *)key baseURL:(NSURL *)baseURL delegate:(id<UHDRemoteDatasourceDelegate>)delegate;

@end


@implementation UHDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

	// initialize event store
	self.eventStore = [[EKEventStore alloc] init];
    
    // configure logging
#ifdef DEBUG
    [VILogger defaultLogger].logLevel = VILogLevelDebug;
#else
    [VILogger defaultLogger].logLevel = VILogLevelWarning;
#endif
    RKLogConfigureByName("RestKit/Network", RKLogLevelOff);
    
    // enable automatic network indicator display
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    

    // setup remote datasources
    [self addRemoteDatasourceForKey:UHDRemoteDatasourceKeyNews baseURL:[[NSURL URLWithString:UHDRemoteAPIBaseURL] URLByAppendingPathComponent:@"news"] delegate:[[UHDNewsRemoteDatasourceDelegate alloc] init]];
    [self addRemoteDatasourceForKey:UHDRemoteDatasourceKeyMensa baseURL:[[NSURL URLWithString:UHDRemoteAPIBaseURL] URLByAppendingPathComponent:@"mensa"] delegate:[[UHDMensaRemoteDatasourceDelegate alloc] init]];
    [self addRemoteDatasourceForKey:UHDRemoteDatasourceKeyMaps baseURL:[NSURL URLWithString:UHDRemoteAPIBaseURL] delegate:[[UHDMapsRemoteDatasourceDelegate alloc] init]];
    
    [[[UHDRemoteDatasourceManager defaultManager] remoteDatasourceForKey:UHDRemoteDatasourceKeyMaps] generateSampleDataIfNeeded];

    [[UHDRemoteDatasourceManager defaultManager] refreshAllWithCompletion:nil];
    
    
    // Stitch together generated maps sample data and remote data from server
    // TODO: remove when maps remote data becomes available!
    
    NSManagedObjectContext *managedObjectContext = self.persistentStack.managedObjectContext;
    // get mensa category
    NSFetchRequest *categoryFetchRequest = [NSFetchRequest fetchRequestWithEntityName:[UHDLocationCategory entityName]];
    categoryFetchRequest.predicate = [NSPredicate predicateWithFormat:@"title == %@", @"Mensen"];
    UHDLocationCategory *mensenCategory = [[managedObjectContext executeFetchRequest:categoryFetchRequest error:nil] firstObject];
    // get campus regions
    NSFetchRequest *regionsFetchRequest = [NSFetchRequest fetchRequestWithEntityName:[UHDCampusRegion entityName]];
    NSArray *campusRegions = [managedObjectContext executeFetchRequest:regionsFetchRequest error:nil];
    // get mensen
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[UHDMensa entityName]];
    NSArray *mensen = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
    for (UHDMensa *mensa in mensen) {
        if (!mensa.category) {
            mensa.category = mensenCategory;
        }
        if ([mensa.title isEqualToString:@"Triplex-Mensa"]) {
            if (!mensa.campusRegion) {
                for (UHDCampusRegion *campusRegion in campusRegions) {
                    if ([campusRegion.identifier isEqualToString:@"ALT"]) {
                        mensa.campusRegion = campusRegion;
                        break;
                    }
                }
            }
            if (!mensa.address) {
                UHDAddress *address = [UHDAddress insertNewObjectIntoContext:managedObjectContext];
                address.street = @"Grabengasse 14 (Universitätsplatz)";
                address.city = @"Heidelberg";
                address.postalCode = @"69117";
                mensa.address = address;
            }
            if (!mensa.buildingNumber) {
                mensa.buildingNumber = @"2100";
            }
        }
        if ([mensa.title isEqualToString:@"Zentralmensa"]) {
            if (!mensa.campusRegion) {
                for (UHDCampusRegion *campusRegion in campusRegions) {
                    if ([campusRegion.identifier isEqualToString:@"INF"]) {
                        mensa.campusRegion = campusRegion;
                        break;
                    }
                }
            }
            if (!mensa.address) {
                UHDAddress *address = [UHDAddress insertNewObjectIntoContext:managedObjectContext];
                address.street = @"Im Neuenheimer Feld 304";
                address.city = @"Heidelberg";
                address.postalCode = @"69120";
                mensa.address = address;
            }
            if (!mensa.buildingNumber) {
                mensa.buildingNumber = @"304";
            }
        }
        if ([mensa.title isEqualToString:@"zeughaus"]) {
            if (!mensa.campusRegion) {
                for (UHDCampusRegion *campusRegion in campusRegions) {
                    if ([campusRegion.identifier isEqualToString:@"ALT"]) {
                        mensa.campusRegion = campusRegion;
                        break;
                    }
                }
            }
            if (!mensa.address) {
                UHDAddress *address = [UHDAddress insertNewObjectIntoContext:managedObjectContext];
                address.street = @"Marstallhof 3";
                address.city = @"Heidelberg";
                address.postalCode = @"69117";
                mensa.address = address;
            }
            if (!mensa.buildingNumber) {
                mensa.buildingNumber = @"2010";
            }
        }
        if (!mensa.url) {
            mensa.url = [NSURL URLWithString:@"http://www.studentenwerk.uni-heidelberg.de/mensen"];
        }
    }
    // get kip building
    NSFetchRequest *kipFetchRequest = [NSFetchRequest fetchRequestWithEntityName:[UHDBuilding entityName]];
    kipFetchRequest.predicate = [NSPredicate predicateWithFormat:@"buildingNumber == %@", @"227"];
    UHDBuilding *kipBuilding = [[managedObjectContext executeFetchRequest:kipFetchRequest error:nil] firstObject];
    // get all events in kip
    NSFetchRequest *eventsInKIPFetchRequest = [NSFetchRequest fetchRequestWithEntityName:[UHDEventItem entityName]];
    eventsInKIPFetchRequest.predicate = [NSPredicate predicateWithFormat:@"buildingString LIKE[cd] %@", @"Kirchhoff-Institut für Physik"];
    NSArray *eventsInKIP = [managedObjectContext executeFetchRequest:eventsInKIPFetchRequest error:nil];
    for (UHDEventItem *eventInKIP in eventsInKIP) {
        if (!eventInKIP.location) {
            eventInKIP.location = kipBuilding;
        }
    }
    [managedObjectContext saveToPersistentStore:nil];
    

    
    // configure default styles
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [UINavigationBar appearance].barTintColor = [UIColor brandColor];
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    [UINavigationBar appearance].titleTextAttributes = @{ NSForegroundColorAttributeName: [UIColor whiteColor] };
    [UILabel appearanceWhenContainedIn:[UINavigationBar class], nil].textColor = [UIColor whiteColor];

    
    // setup initial view controllers
    
    // Mensa
    UIStoryboard *mensaStoryboard = [UIStoryboard storyboardWithName:@"mensa" bundle:nil];
    UINavigationController *mensaNavC = [mensaStoryboard instantiateInitialViewController];
    UHDMensaViewController *mainMensaVC = (UHDMensaViewController *)mensaNavC.topViewController;
    mainMensaVC.managedObjectContext = self.persistentStack.managedObjectContext;
    
    // News
    UIStoryboard *newsStoryboard = [UIStoryboard storyboardWithName:@"news" bundle:nil];
    UINavigationController *newsNavC = [newsStoryboard instantiateInitialViewController];
    UHDNewsViewController *newsVC = (UHDNewsViewController *)newsNavC.topViewController;
    newsVC.managedObjectContext = self.persistentStack.managedObjectContext;
    
    // Maps
    UIStoryboard *mapsStoryboard = [UIStoryboard storyboardWithName:@"maps" bundle:nil];
    UINavigationController *mapsNavC = [mapsStoryboard instantiateInitialViewController];
    UHDMapsViewController *mapsVC = (UHDMapsViewController *)mapsNavC.topViewController;
    mapsVC.managedObjectContext = self.persistentStack.managedObjectContext;
    
    // Settings
    UIStoryboard *settingsStoryboard = [UIStoryboard storyboardWithName:@"settings" bundle:nil];
    UINavigationController *settingsNavC = [settingsStoryboard instantiateInitialViewController];
    UHDSettingsViewController *settingsVC = (UHDSettingsViewController *)settingsNavC.topViewController;
    settingsVC.managedObjectContext = self.persistentStack.managedObjectContext;
    

    // create and populate tab bar controller
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[mensaNavC, newsNavC, mapsNavC, settingsNavC];
    
    // create and populate window
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.tintColor = [UIColor brandColor];
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];

    
    return YES;
}


#pragma mark - Persistent Stack

- (UHDPersistentStack *)persistentStack {
    if (!_persistentStack) {
        [self.logger log:@"Creating persistent stack ..." forLevel:VILogLevelVerbose];
        
        NSManagedObjectModel *mensaModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"mensa" withExtension:@"momd"]];
        NSManagedObjectModel *newsModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"news" withExtension:@"momd"]];
        NSManagedObjectModel *mapsModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"maps" withExtension:@"momd"]];
        NSManagedObjectModel *managedObjectModel = [self modelByMergingModels:@[ mensaModel, newsModel, mapsModel ] withForeignEntityNameKey:@"UHDForeignEntityNameKey"];

        NSURL *persistentStoreURL = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:@"uni-hd.sqlite"];
        
        _persistentStack = [[UHDPersistentStack alloc] initWithManagedObjectModel:managedObjectModel persistentStoreURL:persistentStoreURL];
    }
    return _persistentStack;
}

- (NSManagedObjectModel *)modelByMergingModels:(NSArray *)models withForeignEntityNameKey:(NSString *)foreignEntityNameKey
{
    NSManagedObjectModel *mergedModel = [[NSManagedObjectModel alloc] init];
    
    // Merge entities of all models, ignoring placeholder entities marked by existence of the foreignEntityNameKey in their userInfo
    NSMutableArray *mergedModelEntities = [[NSMutableArray alloc] init];
    NSMutableDictionary *ignoredSubentities = [[NSMutableDictionary alloc] init];
    for (NSManagedObjectModel *model in models) {
        for (NSEntityDescription *entity in model.entities) {
            if ([entity.userInfo objectForKey:foreignEntityNameKey]) {
                // Ignore placeholder
                // TODO: use this key to actually map differently-named entities
                // remember subentities to re-establish later
                ignoredSubentities[entity.name] = entity.subentities;
            } else {
                [mergedModelEntities addObject:[entity copy]];
            }
        }
    }
    [mergedModel setEntities:mergedModelEntities];
    
    // Merge subentities
    NSDictionary *entitiesByName = [mergedModel entitiesByName];
    for (NSEntityDescription *entity in mergedModel.entities) {
        NSMutableArray *mergedSubentities = [[NSMutableArray alloc] init];
        for (NSEntityDescription *ignoredSubentity in ignoredSubentities[entity.name]) {
            [mergedSubentities addObject:entitiesByName[ignoredSubentity.name]];
        }
        for (NSEntityDescription *subentity in entity.subentities) {
            [mergedSubentities addObject:entitiesByName[subentity.name]];
        }
        entity.subentities = mergedSubentities;
    }
    
    return mergedModel;
}


#pragma mark - Remote Datasources

- (void)addRemoteDatasourceForKey:(NSString *)key baseURL:(NSURL *)baseURL delegate:(id<UHDRemoteDatasourceDelegate>)delegate
{
    UHDRemoteDatasource *remoteDatasource = [[UHDRemoteDatasource alloc] initWithPersistentStack:self.persistentStack remoteBaseURL:baseURL];
    
    if (!self.remoteDatasourceDelegates) self.remoteDatasourceDelegates = [[NSMutableArray alloc] init];
    [self.remoteDatasourceDelegates addObject:delegate];
    remoteDatasource.delegate = delegate;
    
    [[UHDRemoteDatasourceManager defaultManager] addRemoteDatasource:remoteDatasource forKey:key];
}

@end
