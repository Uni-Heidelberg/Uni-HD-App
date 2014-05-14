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
#import "UHDPersistentStack.h"
#import "UHDNewsStore.h"
#import "UHDMensaStore.h"


@interface UHDAppDelegate ()

@property (strong, nonatomic) UHDPersistentStack *persistentStack;

@end


@implementation UHDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // Default Logger configuration
    [VILogger defaultLogger].logLevel = VILogLevelDebug;
    
    
    // Setup Module Stores
    [UHDNewsStore defaultStore].managedObjectContext = self.persistentStack.managedObjectContext;
    [UHDMensaStore defaultStore].managedObjectContext = self.persistentStack.managedObjectContext;
    

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
    NSArray *viewControllers = @[initialNewsViewController, initialMensaViewController];
    for(UINavigationController *viewController in viewControllers) {
        if ([viewController.topViewController respondsToSelector:@selector(setManagedObjectContext:)]) {
            [((id)viewController.topViewController) setManagedObjectContext:self.persistentStack.managedObjectContext];
        }
    }
    tabBarController.viewControllers = viewControllers;
    
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


#pragma mark - Persistent Stack

- (UHDPersistentStack *)persistentStack {
    if (!_persistentStack) {
        
        NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];

        NSURL *persistentStoreURL = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:@"uni-hd.sqlite"];
        
        _persistentStack = [[UHDPersistentStack alloc] initWithManagedObjectModel:managedObjectModel persistentStoreURL:persistentStoreURL];
    }
    return _persistentStack;
}

@end
