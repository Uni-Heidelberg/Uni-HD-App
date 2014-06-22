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


@interface UHDMainMensaViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (strong, nonatomic) UHDMensa *mensa;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@property (strong, nonatomic) UIPageViewController *pageViewController;

- (void)configureView;

- (IBAction)todayButtonPressed:(id)sender;
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

- (void)userDefaultsDidChange:(NSNotification *)notification
{
    [self loadSelectedMensa];
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
    [self.pageViewController setViewControllers:@[ [self dailyMenuViewControllerForDate:[NSDate date]] ] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [self configureView];
}

- (void)configureView
{
    self.titleLabel.text = self.mensa ? self.mensa.title : NSLocalizedString(@"No Mensa selected", nil);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterLongStyle;
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
    self.dateLabel.text = [dateFormatter stringFromDate:[(UHDDailyMenuViewController *)self.pageViewController.viewControllers[0] date]];
}


#pragma mark - User Interaction

- (IBAction)todayButtonPressed:(id)sender
{
    [self.pageViewController setViewControllers:@[ [self dailyMenuViewControllerForDate:[NSDate date]] ] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [self configureView];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showSelectMensa"]) {
        UHDMensaViewController *mensaVC = [segue.destinationViewController viewControllers][0];
        mensaVC.managedObjectContext = self.managedObjectContext;
    } else if ([segue.identifier isEqualToString:@"embedPageVC"]) {
        self.pageViewController = segue.destinationViewController;
        self.pageViewController.dataSource = self;
        self.pageViewController.delegate = self;
        [self.pageViewController setViewControllers:@[ [self dailyMenuViewControllerForDate:[NSDate date]] ] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }
}

- (void)unwindToMainMensa:(UIStoryboardSegue *)segue
{
    
}


#pragma mark - Page View Controller Delegate

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    [self configureView];
}


#pragma mark - Page View Controller Datasource

- (UHDDailyMenuViewController *)dailyMenuViewControllerForDate:(NSDate *)date
{
    UHDDailyMenuViewController *dailyMenuVC = [self.storyboard instantiateViewControllerWithIdentifier:@"dailyMenu"];
    dailyMenuVC.dailyMenu = [self.mensa dailyMenuForDate:date];
    dailyMenuVC.date = date;
    return dailyMenuVC;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    UHDDailyMenuViewController *currentDailyMenuVC = (UHDDailyMenuViewController *)viewController;
    NSDateComponents *oneDay = [[NSDateComponents alloc] init];
    oneDay.day = 1;
    NSDate *nextDate = [[NSCalendar currentCalendar] dateByAddingComponents:oneDay toDate:currentDailyMenuVC.date options:0];
    return [self dailyMenuViewControllerForDate:nextDate];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    UHDDailyMenuViewController *currentDailyMenuVC = (UHDDailyMenuViewController *)viewController;
    NSDateComponents *oneDay = [[NSDateComponents alloc] init];
    oneDay.day = -1;
    NSDate *prevDate = [[NSCalendar currentCalendar] dateByAddingComponents:oneDay toDate:currentDailyMenuVC.date options:0];
    return [self dailyMenuViewControllerForDate:prevDate];
}

@end
