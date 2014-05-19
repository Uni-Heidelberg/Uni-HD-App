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
#import "UHDMensaViewController.h"

// Stores
#import "UHDPersistentStack.h"
#import "UHDNewsStore.h"
#import "UHDMensaStore.h"


@interface UHDAppDelegate ()

@property (strong, nonatomic) UHDPersistentStack *persistentStack;
@property (strong, nonatomic) UHDNewsStore *newsStore;
@property (strong, nonatomic) UHDMensaStore *mensaStore;

- (void)generateSampleDataConditionally:(BOOL)conditionally;

@end


@implementation UHDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // Default Logger configuration
    [VILogger defaultLogger].logLevel = VILogLevelDebug;
    

    // Create Module View Controllers
    
    // News
    UIStoryboard *newsStoryboard = [UIStoryboard storyboardWithName:@"news" bundle:nil];
    UINavigationController *newsNavC = [newsStoryboard instantiateInitialViewController];
    newsNavC.tabBarItem.title = NSLocalizedString(@"News", nil);
    UHDNewsViewController *newsVC = newsNavC.viewControllers[0];
    newsVC.remoteDatasource = self.newsStore;
    
    // Mensa
    UIStoryboard *mensaStoryboard = [UIStoryboard storyboardWithName:@"mensa" bundle:nil];
    UINavigationController *mensaNavC = [mensaStoryboard instantiateInitialViewController];
    mensaNavC.tabBarItem.title = NSLocalizedString(@"Mensa", nil);
    UHDMensaViewController *mensaVC = mensaNavC.viewControllers[0];
    mensaVC.remoteDatasource = self.mensaStore;
    
    
    // Create and populate tab bar controller
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[mensaNavC, newsNavC];
    
    // Create and populate window
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.tintColor = [UIColor colorWithRed:181/255. green:21/255. blue:43/255. alpha:1]; // set brand tint color TODO: move in category
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
    
    
    // generate sample data
    [self generateSampleDataConditionally:YES];
    
    
    return YES;
}


#pragma mark - Persistent Stack

- (UHDPersistentStack *)persistentStack {
    if (!_persistentStack) {
        
        NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];

        NSURL *persistentStoreURL = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:@"uni-hd.sqlite"];
        
        _persistentStack = [[UHDPersistentStack alloc] initWithManagedObjectModel:managedObjectModel persistentStoreURL:persistentStoreURL];
    }
    return _persistentStack;
}

#pragma mark - Module Stores
- (UHDNewsStore *)newsStore {
    if (!_newsStore) {
        self.newsStore = [[UHDNewsStore alloc] initWithPersistentStack:self.persistentStack];
    }
    return _newsStore;
}
- (UHDMensaStore *)mensaStore {
    if (!_mensaStore) {
        self.mensaStore = [[UHDMensaStore alloc] initWithPersistentStack:self.persistentStack];
    }
    return _mensaStore;
}

#pragma mark - Sample Data

- (void)generateSampleDataConditionally:(BOOL)conditionally {
    for (id <UHDRemoteDatasource> remoteDatasource in @[self.newsStore, self.mensaStore]) {
        if (conditionally && remoteDatasource.allItems.count > 0) continue;
        [remoteDatasource generateSampleData];
    }
}

@end
