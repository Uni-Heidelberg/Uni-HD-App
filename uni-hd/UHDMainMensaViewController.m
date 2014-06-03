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
@property (strong, nonatomic) UHDDailyMenuViewController *dailyMenuVC;
@end

@implementation UHDMainMensaViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.mensa==nil) {
        [self mensaButtonPressed:self];    }
    else {
        [self updateDailyMenuViewController];

    }
    
}
- (void)updateDailyMenuViewController {
    self.dailyMenuVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DailyMenuViewController"];
    //get model Data
    UHDDailyMenu *dailyMenu = [[self.mensa.menus sortedArrayUsingDescriptors:@[ [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES] ]] lastObject];
    self.dailyMenuVC.dailyMenu = dailyMenu;
    //pass model data and create dailymenuVC
    self.dailyMenuVC.dailyMenu = dailyMenu;
    
    [self addChildViewController: self.dailyMenuVC];
    self.dailyMenuVC.view.frame = self.view.frame;
    [self.DailyMenuViewContainer addSubview:self.dailyMenuVC.view];
    [self.dailyMenuVC didMoveToParentViewController:self];
}

- (void)done:(UHDMensa *)mensa {
    self.mensa = mensa;
    [self.mensaVC willMoveToParentViewController:nil];
    [self.mensaVC.view removeFromSuperview];
    [self.mensaVC removeFromParentViewController];
    [self updateDailyMenuViewController];
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
    [self.MensaViewContainer addSubview:self.mensaVC.view];
    [self.mensaVC didMoveToParentViewController:self];
}
@end
