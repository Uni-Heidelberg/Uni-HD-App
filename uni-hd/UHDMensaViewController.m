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


@interface UHDMensaViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate, UHDMensaDayPickerDelegate>

@property (strong, nonatomic) UHDMensa *mensa;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UHDMensaDayPicker *dayPicker;

@property (strong, nonatomic) UIPageViewController *pageViewController;

- (void)configureView;

- (IBAction)quickDateSelectionButtonPressed:(id)sender;
- (IBAction)unwindToMainMensa:(UIStoryboardSegue *)segue;

@end


@implementation UHDMensaViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self loadSelectedMensa];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDefaultsDidChange:) name:NSUserDefaultsDidChangeNotification object:[NSUserDefaults standardUserDefaults]];
    
    self.dayPicker.itemWidth = self.dayPicker.bounds.size.width / 7;
    self.dayPicker.delegate = self; // TODO: move to storyboard
    [self.dayPicker selectDate:[NSDate date] animated:NO scrollPosition:UICollectionViewScrollPositionLeft];

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
        [self.logger log:@"Found selected Mensa" object:self.mensa.title forLevel:VILogLevelDebug];
    } else {
        [self.logger log:@"Selected invalid mensa" forLevel:VILogLevelError];
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
    self.titleLabel.text = (self.mensa != nil) ? self.mensa.title : NSLocalizedString(@"No Mensa selected", nil);

    UIBarButtonItem *quickDateSelectionButton = self.navigationItem.rightBarButtonItem;
    quickDateSelectionButton.title = self.dayPicker.selectedDate != nil && [[NSCalendar currentCalendar] isDateInToday:self.dayPicker.selectedDate] ? NSLocalizedString(@"Tomorrow", nil) : NSLocalizedString(@"Today", nil);

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterLongStyle;
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
    //self.dateLabel.text = [dateFormatter stringFromDate:[(UHDDailyMenuViewController *)self.pageViewController.viewControllers[0] date]];
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
        [self.pageViewController setViewControllers:@[ [self dailyMenuViewControllerForDate:[NSDate date]] ] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil]; // default (initial) view controller
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
}


#pragma mark - Day Picker Delegate

- (BOOL)dayPicker:(UHDMensaDayPicker *)dayPicker canSelectDate:(NSDate *)date
{
    return [self.mensa dailyMenuForDate:date] != nil;
}

- (void)dayPicker:(UHDMensaDayPicker *)dayPicker didSelectDate:(NSDate *)date previousDate:(NSDate *)previousDate
{
    if (!date) {
        // TODO
    } else if (![[NSCalendar currentCalendar] isDate:date inSameDayAsDate:((UHDDailyMenuViewController *)self.pageViewController.viewControllers.firstObject).date]) {
        [self.pageViewController setViewControllers:@[ [self dailyMenuViewControllerForDate:date] ] direction:([date compare:previousDate] == NSOrderedAscending) ? UIPageViewControllerNavigationDirectionReverse : UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    }
    [self configureView];
}


#pragma mark - Page View Controller Delegate

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    [self.dayPicker selectDate:((UHDDailyMenuViewController *)pageViewController.viewControllers.firstObject).date animated:YES scrollPosition:UICollectionViewScrollPositionLeft];
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
