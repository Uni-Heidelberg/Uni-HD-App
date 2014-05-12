//
//  UHDAppDelegate.m
//  uni-hd
//
//  Created by Nils Fischer on 24.04.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDAppDelegate.h"

// View Controllers
#import "UHDNewsViewController.h"

// Stores
#import "UHDNewsStore.h"
#import "UHDMensaStore.h"


@interface UHDAppDelegate ()

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory;

@end

@implementation UHDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // Default Logger configuration
    [VILogger defaultLogger].logLevel = VILogLevelDebug;
    

    // Create Module View Controllers
    // News
    UIStoryboard *newsStoryboard = [UIStoryboard storyboardWithName:@"news" bundle:nil];
    UIViewController *initialNewsViewController = [newsStoryboard instantiateInitialViewController];
    initialNewsViewController.tabBarItem.title = NSLocalizedString(@"News", nil);
    // Mensa
    UIStoryboard *mensaStoryboard = [UIStoryboard storyboardWithName:@"mensa" bundle:nil];
    UIViewController *initialMensaViewController = [mensaStoryboard instantiateInitialViewController];
    initialMensaViewController.tabBarItem.title = NSLocalizedString(@"Mensa", nil);
    
    // Create and populate tab bar controller
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[initialNewsViewController, initialMensaViewController];
    
    // Create and populate window
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.tintColor = [UIColor colorWithRed:181/255. green:21/255. blue:43/255. alpha:1]; // set brand tint color TODO: move in category
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
    
    
    // generate sample data
    [[UHDNewsStore defaultStore] generateSampleDataConditionally:YES];
    [[UHDMensaStore defaultStore] generateSampleDataConditionally:YES];
    
    
    return YES;
}


#pragma mark - Core Data Stack

- (NSManagedObjectContext *)managedObjectContext
{
    if (!_managedObjectContext) {
    
        if (self.persistentStoreCoordinator) {
            _managedObjectContext = [[NSManagedObjectContext alloc] init];
            [_managedObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
        }
        
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (!_managedObjectModel) {

        _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
        
    }
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (!_persistentStoreCoordinator) {
        
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        NSError *error = nil;
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"uni-hd.sqlite"] options:@{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES} error:&error]) {

            [self.logger log:@"Setup Persistent Store" error:error];
            abort();
            
        }
        
    }
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
