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
#import "UHDMainMensaViewController.h"


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
    RKLogConfigureByName("RestKit", RKLogLevelOff);
    
    
    // enable automatic network indicator display
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    
    // setup remote datasources
    [self addRemoteDatasourceForKey:UHDRemoteDatasourceKeyNews baseURL:[NSURL URLWithString:UHDRemoteBaseURL] delegate:[[UHDNewsRemoteDatasourceDelegate alloc] init]];
    [[[UHDRemoteDatasourceManager defaultManager] remoteDatasourceForKey:UHDRemoteDatasourceKeyNews] refreshWithCompletion:nil];
    [self addRemoteDatasourceForKey:UHDRemoteDatasourceKeyMensa baseURL:[NSURL URLWithString:UHDRemoteBaseURL] delegate:[[UHDMensaRemoteDatasourceDelegate alloc] init]];
    [[[UHDRemoteDatasourceManager defaultManager] remoteDatasourceForKey:UHDRemoteDatasourceKeyMensa] refreshWithCompletion:nil];

    
    // generate sample data
    [self generateSampleDataConditionally:YES];

    
    // setup initial view controllers
    
    // News
    UIStoryboard *newsStoryboard = [UIStoryboard storyboardWithName:@"news" bundle:nil];
    UINavigationController *newsNavC = [newsStoryboard instantiateInitialViewController];
    UHDNewsViewController *newsVC = newsNavC.viewControllers[0];
    newsVC.managedObjectContext = self.persistentStack.managedObjectContext;
    
    // Mensa
    UIStoryboard *mensaStoryboard = [UIStoryboard storyboardWithName:@"mensa" bundle:nil];
    UINavigationController *mensaNavC = [mensaStoryboard instantiateInitialViewController];
    UHDMainMensaViewController *mainMensaVC = mensaNavC.viewControllers[0];
    mainMensaVC.managedObjectContext = self.persistentStack.managedObjectContext;


    // create and populate tab bar controller
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[mensaNavC, newsNavC];
    
    // create and populate window
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.tintColor = [UIColor brandColor];   // set brand tint color TODO: move in category
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];

    // configure default navigation bar style and status bar style
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [UINavigationBar appearance].barTintColor = [UIColor brandColor];
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    [UINavigationBar appearance].titleTextAttributes = @{ NSForegroundColorAttributeName: [UIColor whiteColor] };
    [UILabel appearanceWhenContainedIn:[UINavigationBar class], nil].textColor = [UIColor whiteColor];

    return YES;
}


#pragma mark - Persistent Stack

- (UHDPersistentStack *)persistentStack {
    if (!_persistentStack) {
        [self.logger log:@"Creating persistent stack ..." forLevel:VILogLevelVerbose];
        
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
