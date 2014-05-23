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

// View Controllers
#import "UHDNewsViewController.h"
#import "UHDMensaViewController.h"

// Views
#import "UIColor+UHDBrandColor.h"


@interface UHDAppDelegate ()

@property (strong, nonatomic) UHDPersistentStack *persistentStack;
@property (strong, nonatomic) NSMutableArray *remoteDatasourceDelegates;

- (void)addRemoteDatasourceForKey:(NSString *)key baseURL:(NSURL *)baseURL delegate:(id<UHDRemoteDatasourceDelegate>)delegate;
- (void)generateSampleDataConditionally:(BOOL)conditionally;

@end


@implementation UHDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // configure logging
    [VILogger defaultLogger].logLevel = VILogLevelDebug;
    RKLogConfigureByName("RestKit", RKLogLevelDefault);
    [VILogger loggerForClass:[UHDRemoteDatasource class]].logLevel = VILogLevelVerbose;
    
    
    // enable automatic network indicator display
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    
    // setup remote datasources
    // [self addRemoteDatasourceForKey:UHDRemoteDatasourceKeyNews baseURL:[NSURL URLWithString:UHDRemoteBaseURL] delegate:[[UHDNewsRemoteDatasourceDelegate alloc] init]];
    // [[[UHDRemoteDatasourceManager defaultManager] remoteDatasourceForKey:UHDRemoteDatasourceKeyNews] refresh];

    
    // generate sample data
    [self generateSampleDataConditionally:YES];

    
    // setup initial view controllers
    
    // News
    UIStoryboard *newsStoryboard = [UIStoryboard storyboardWithName:@"news" bundle:nil];
    UINavigationController *newsNavC = [newsStoryboard instantiateInitialViewController];
    newsNavC.tabBarItem.title = NSLocalizedString(@"News", nil);
    UHDNewsViewController *newsVC = newsNavC.viewControllers[0];
    newsVC.managedObjectContext = self.persistentStack.managedObjectContext;
    
    // Mensa
    UIStoryboard *mensaStoryboard = [UIStoryboard storyboardWithName:@"mensa" bundle:nil];
    UINavigationController *mensaNavC = [mensaStoryboard instantiateInitialViewController];
    mensaNavC.tabBarItem.title = NSLocalizedString(@"Mensa", nil);
    UHDMensaViewController *mensaVC = mensaNavC.viewControllers[0];
    mensaVC.managedObjectContext = self.persistentStack.managedObjectContext;
    
    // create and populate tab bar controller
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[mensaNavC, newsNavC];
    
    // create and populate window
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.tintColor = [UIColor brandColor]; // set brand tint color TODO: move in category
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];

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


#pragma mark - Remote Datasources

- (void)addRemoteDatasourceForKey:(NSString *)key baseURL:(NSURL *)baseURL delegate:(id<UHDRemoteDatasourceDelegate>)delegate
{
    UHDRemoteDatasource *remoteDatasource = [[UHDRemoteDatasource alloc] initWithPersistentStack:self.persistentStack remoteBaseURL:baseURL];
    
    if (!self.remoteDatasourceDelegates) self.remoteDatasourceDelegates = [[NSMutableArray alloc] init];
    [self.remoteDatasourceDelegates addObject:delegate];
    remoteDatasource.delegate = delegate;
    
    [[UHDRemoteDatasourceManager defaultManager] addRemoteDatasource:remoteDatasource forKey:key];
}

#pragma mark - Sample Data

- (void)generateSampleDataConditionally:(BOOL)conditionally {
    for (UHDRemoteDatasource *remoteDatasource in [[UHDRemoteDatasourceManager defaultManager] allRemoteDatasources]) {
        if (conditionally && remoteDatasource.allItems.count > 0) continue;
        [remoteDatasource generateSampleData];
    }
}

@end
