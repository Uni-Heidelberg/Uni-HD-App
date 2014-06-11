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

@property (strong, nonatomic) UHDDailyMenuViewController *dailyMenuVC;
@property (strong, nonatomic) UHDMensa *mensa;
@property (strong, nonatomic) UILabel *chooseMensaLabel;

- (void)configureView;

- (IBAction)unwindToMainMensa:(UIStoryboardSegue *)segue;

@end

@implementation UHDMainMensaViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadSelectedMensa];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDefaultsDidChange:) name:NSUserDefaultsDidChangeNotification object:[NSUserDefaults standardUserDefaults]];
    
    [self configureView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.mensa) {
        self.chooseMensaLabel = [[UILabel alloc]initWithFrame:self.view.frame];
        [self.view addSubview:self.chooseMensaLabel];
        self.chooseMensaLabel.text = [NSString stringWithFormat:@"Bitte wähle zunächst eine Mensa"];
        self.chooseMensaLabel.textAlignment = NSTextAlignmentCenter;
    } else {
        [self.chooseMensaLabel removeFromSuperview];
    }
    
}

- (void)loadSelectedMensa
{
    [self.logger log:@"loading selected mensa from user defaults..." forLevel:VILogLevelVerbose];
    
    NSNumber *mensaId = [[NSUserDefaults standardUserDefaults] objectForKey:UHDUserDefaultsKeySelectedMensaId];
    if (!mensaId) {
        [self.logger log:@"no mensa selected" forLevel:VILogLevelVerbose];
        return;
    }
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[UHDMensa entityName]];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"remoteObjectId == %@", mensaId];
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:NULL];
    if (result.count > 0) {
        self.mensa = result.firstObject;
    } else {
        [self.logger log:@"selected invalid mensa" forLevel:VILogLevelError];
    }
}

- (void)setMensa:(UHDMensa *)mensa
{
    if (mensa == _mensa) return;
    _mensa = mensa;
    [self configureView];
}

- (void)configureView
{
    self.title = self.mensa ? self.mensa.title : NSLocalizedString(@"No Mensa selected", nil);
    
    UHDDailyMenu *dailyMenu = [[self.mensa.menus sortedArrayUsingDescriptors:@[ [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES] ]] lastObject];

    self.dailyMenuVC.dailyMenu = dailyMenu;
}


#pragma mark - User Defaults Change Callback

- (void)userDefaultsDidChange:(NSNotification *)notification
{
    [self loadSelectedMensa];
}


#pragma mark - User Interaction

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showSelectMensa"]) {
        UHDMensaViewController *mensaVC = [segue.destinationViewController viewControllers][0];
        mensaVC.managedObjectContext = self.managedObjectContext;
    } else if ([segue.identifier isEqualToString:@"embedDailyMenu"]) {
        self.dailyMenuVC = segue.destinationViewController;
    }
}

- (void)unwindToMainMensa:(UIStoryboardSegue *)segue
{
    
}

@end
