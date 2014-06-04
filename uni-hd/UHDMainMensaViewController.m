//
//  UHDMainMensaViewController.m
//  uni-hd
//
//  Created by Felix on 03.06.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDMainMensaViewController.h"

// View Controller
#import "UHDMensaViewController.h"
#import "UHDDailyMenuViewController.h"

// Model
#import "UHDMensa.h"


@interface UHDMainMensaViewController ()

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) UHDDailyMenuViewController *dailyMenuVC;
@property (strong, nonatomic) UHDMensa *mensa;

- (void)configureForMensa:(UHDMensa *)mensa;

- (IBAction)unwindToMainMensa:(UIStoryboardSegue *)segue;

@end

@implementation UHDMainMensaViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDefaultsDidChange:) name:NSUserDefaultsDidChangeNotification object:[NSUserDefaults standardUserDefaults]];
    
    [self configureForMensa:self.mensa];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!self.mensa) {
        [self performSegueWithIdentifier:@"showSelectMensa" sender:self];
    }
}

- (void)setMensa:(UHDMensa *)mensa
{
    if (mensa==_mensa) return;
    _mensa = mensa;
    [self configureForMensa:mensa];
}

- (void)configureForMensa:(UHDMensa *)mensa
{
    self.title = mensa.title;
    
    UHDDailyMenu *dailyMenu = [[mensa.menus sortedArrayUsingDescriptors:@[ [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES] ]] lastObject];

    self.dailyMenuVC.dailyMenu = dailyMenu;
}


#pragma mark - User Defaults Change Callback

- (void)userDefaultsDidChange:(NSNotification *)notification
{
    NSNumber *mensaId = [[NSUserDefaults standardUserDefaults] objectForKey:UHDUserDefaultsKeySelectedMensaId];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[UHDMensa entityName]];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"remoteObjectId == %@", mensaId];
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:NULL];
    if (result.count > 0) {
        self.mensa = result.firstObject;
    } else {
        [self.logger log:@"selected invalid mensa" forLevel:VILogLevelError];
    }
}



#pragma mark - User Interaction

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showSelectMensa"]) {
        UHDMensaViewController *mensaVC = [segue.destinationViewController viewControllers][0];
        mensaVC.managedObjectContext = self.managedObjectContext;
    } else if ([segue.identifier isEqualToString:@"embedDailyMenuVC"]) {
        self.dailyMenuVC = segue.destinationViewController;
    }
}

- (void)unwindToMainMensa:(UIStoryboardSegue *)segue
{
    
}

@end
