//
//  UHDMainMensaViewController.m
//  uni-hd
//
//  Created by Felix on 03.06.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDMensaViewController.h"

// View Controller
#import "UHDMensaListViewController.h"
#import "UHDDailyMenuViewController.h"
#import "UHDMensaDetailViewController.h"

// Model
#import "UHDMensa.h"


@interface UHDMensaViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate, MensaDayPickerDelegate>

@property (strong, nonatomic) UHDMensa *mensa;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet MensaDayPicker *dayPicker;

@property (strong, nonatomic) UIPageViewController *pageViewController;

- (void)configureViewAnimated:(BOOL)animated;

- (IBAction)quickDateSelectionButtonPressed:(id)sender;
- (IBAction)unwindToMainMensa:(UIStoryboardSegue *)segue;

- (UHDDailyMenuViewController *)dailyMenuViewControllerForDate:(NSDate *)date;

@end


@implementation UHDMensaViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self loadSelectedMensa];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDefaultsDidChange:) name:NSUserDefaultsDidChangeNotification object:[NSUserDefaults standardUserDefaults]];
    
    self.dayPicker.itemWidth = 45; // TODO: make dynamic
    self.dayPicker.delegate = self; // TODO: move to storyboard
    [self.dayPicker selectDate:[NSDate date] animated:NO scrollPosition:UICollectionViewScrollPositionLeft];
    
    [self configureViewAnimated:NO];

}

- (void)userDefaultsDidChange:(NSNotification *)notification
{
    [self loadSelectedMensa];
}

- (void)loadSelectedMensa
{
    [self.logger log:@"Loading selected mensa from user defaults..." forLevel:VILogLevelDebug];
    
    NSNumber *mensaId = [[NSUserDefaults standardUserDefaults] objectForKey:UHDUserDefaultsKeySelectedMensaId];
    if (!mensaId) {
        [self.logger log:@"No mensa selected" forLevel:VILogLevelDebug];
        return;
    }
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[UHDMensa entityName]];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"remoteObjectId == %@", mensaId];
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:NULL];
    if (result.count > 0) {
        self.mensa = result.firstObject;
        [self.logger log:@"Found selected Mensa." object:self.mensa.title forLevel:VILogLevelDebug];
    } else {
        [self.logger log:@"Selected invalid mensa." forLevel:VILogLevelError];
    }
    
}

- (void)setMensa:(UHDMensa *)mensa
{
    if (mensa == _mensa) return;
    _mensa = mensa;
    [self configureViewAnimated:NO];
}

- (void)configureViewAnimated:(BOOL)animated
{
    self.titleLabel.text = (self.mensa != nil) ? self.mensa.title : NSLocalizedString(@"Keine Mensa ausgewählt", nil);

    UIBarButtonItem *quickDateSelectionButton = self.navigationItem.rightBarButtonItem;
    quickDateSelectionButton.title = self.dayPicker.selectedDate != nil && [[NSCalendar currentCalendar] isDateInToday:self.dayPicker.selectedDate] ? NSLocalizedString(@"Morgen", nil) : NSLocalizedString(@"Heute", nil);
    
    [self.dayPicker reloadData]; // TODO: really necessary here?
    
    [self updateVisibleDailyMenuAnimated:animated];
}

- (void)updateVisibleDailyMenuAnimated:(BOOL)animated
{
    UHDDailyMenuViewController *previousDailyMenuVC = ((UHDDailyMenuViewController *)self.pageViewController.viewControllers.firstObject);
    
    NSDate *date = self.dayPicker.selectedDate;
    NSDate *previousDate = previousDailyMenuVC.date;

    if (!date) {
        // TODO
    } else if (previousDailyMenuVC == nil || previousDailyMenuVC.mensa != self.mensa || ![[NSCalendar currentCalendar] isDate:date inSameDayAsDate:previousDailyMenuVC.date]) {
        [self.pageViewController setViewControllers:@[ [self dailyMenuViewControllerForDate:date] ] direction:([date compare:previousDate] == NSOrderedAscending) ? UIPageViewControllerNavigationDirectionReverse : UIPageViewControllerNavigationDirectionForward animated:animated completion:nil];
    }
}


#pragma mark - User Interaction

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showSelectMensa"]) {
        UHDMensaListViewController *mensaVC = [segue.destinationViewController viewControllers][0];
        mensaVC.managedObjectContext = self.managedObjectContext;
    }
    else if ([segue.identifier isEqualToString:@"embedPageVC"]) {
        self.pageViewController = segue.destinationViewController;
        self.pageViewController.dataSource = self;
        self.pageViewController.delegate = self;
    }
    else if ([segue.identifier isEqualToString:[NSString stringWithFormat:@"showMensaDetail"]]) {
        UHDMensaDetailViewController *detailVC = [segue destinationViewController];
        detailVC.mensa = self.mensa;
    }
}

- (void)unwindToMainMensa:(UIStoryboardSegue *)segue
{
    
}

- (IBAction)quickDateSelectionButtonPressed:(id)sender
{
    NSDate *date = [NSDate date];
    if ([[NSCalendar currentCalendar] isDateInToday:self.dayPicker.selectedDate]) {
        NSDateComponents *oneDay = [[NSDateComponents alloc] init];
        oneDay.day = 1;
        date = [[NSCalendar currentCalendar] dateByAddingComponents:oneDay toDate:date options:0];
    }
    [self.dayPicker selectDate:date animated:YES scrollPosition:UICollectionViewScrollPositionLeft];
    [self configureViewAnimated:YES];
}


#pragma mark - Day Picker Delegate

- (BOOL)dayPicker:(MensaDayPicker *)dayPicker canSelectDate:(NSDate *)date
{
    return [self.mensa hasMenuForDate:date];
}

- (void)dayPicker:(MensaDayPicker *)dayPicker didSelectDate:(NSDate *)date
{
    [self configureViewAnimated:YES];
}


#pragma mark - Page View Controller Delegate

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (completed) {
        [self.dayPicker selectDate:((UHDDailyMenuViewController *)pageViewController.viewControllers.firstObject).date animated:YES scrollPosition:UICollectionViewScrollPositionLeft];
        [self configureViewAnimated:YES];
    }
}


#pragma mark - Page View Controller Datasource

- (UHDDailyMenuViewController *)dailyMenuViewControllerForDate:(NSDate *)date
{
    UHDDailyMenuViewController *dailyMenuVC = [self.storyboard instantiateViewControllerWithIdentifier:@"dailyMenu"];
    dailyMenuVC.mensa = self.mensa;
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
