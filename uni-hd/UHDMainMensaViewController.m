//
//  UHDMainMensaViewController.m
//  uni-hd
//
//  Created by Felix on 03.06.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDMainMensaViewController.h"
#import "UHDMensaViewController.h"
#import "UHDDailyMenuViewController.h"
#import "UHDMensa.h"
#import "VIFetchedResultsControllerDataSource.h"


@interface UHDMainMensaViewController ()

@property (strong, nonatomic) VIFetchedResultsControllerDataSource *fetchedResultsControllerDataSource;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) UHDMensaViewController *mensaVC;

@end

@implementation UHDMainMensaViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UHDDailyMenuViewController *dailyMenuVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DailyMenuViewController"];
    //get model Data
    
    if (self.mensa==nil) {
        [self mensaButtonPressed:self];    }
    else {
        
    UHDDailyMenu *dailyMenu = [[self.mensa.menus sortedArrayUsingDescriptors:@[ [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES] ]] lastObject];
    dailyMenuVC.dailyMenu = dailyMenu;
    //pass model data and create dailymenuVC
    dailyMenuVC.dailyMenu = dailyMenu;
    [self addChildViewController:dailyMenuVC];
    [self.DailyMenuViewContainer addSubview:dailyMenuVC.view];
    }
    
}

- (void)done:(UHDMensa *)mensa {
    self.mensa = mensa;
    [self.mensaVC willMoveToParentViewController:nil];
    [self.mensaVC.view removeFromSuperview];
    [self.mensaVC removeFromParentViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
}

- (IBAction)mensaButtonPressed:(id)sender {
    self.mensaVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MensaViewController"];
    self.mensaVC.delegate = self;
    self.mensaVC.managedObjectContext = self.managedObjectContext;
    
    
    [self addChildViewController: self.mensaVC];
    self.mensaVC.view.frame = self.view.frame;
    [self.view addSubview:self.mensaVC.view];
    [self.mensaVC didMoveToParentViewController:self];
}
@end
