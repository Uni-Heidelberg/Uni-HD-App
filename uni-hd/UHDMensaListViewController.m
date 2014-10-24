//
//  UHDMensaListViewController.m
//  uni-hd
//
//  Created by Felix on 07.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDMensaListViewController.h"

// Table View Datasource
#import "VIFetchedResultsControllerDataSource.h"

// View Controller
#import "UHDMensaViewController.h"
#import "UHDMensaDetailViewController.h"

// View
#import "UHDMensaCell.h"

// Model
#import "UHDMensa.h"

// Swift
#import "uni_hd-Swift.h"

@interface UHDMensaListViewController () <RMSwipeTableViewCellDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet FavouriteMensenView *headerView;
@property (strong, nonatomic) VIFetchedResultsControllerDataSource *fetchedResultsControllerDataSource;

@property (strong, nonatomic) CLLocationManager *locationManager;



@property (weak, nonatomic) IBOutlet UISegmentedControl *sortControl;

- (IBAction)sortControlValueChanged:(id)sender;
- (IBAction)refreshControlValueChanged:(id)sender;

@end


@implementation UHDMensaListViewController


#pragma mark - View Lifecycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // Configure View
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 90;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Setup CLLocationManager
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest; // TODO: reconsider accuracy
    self.locationManager.delegate = self;
    // trigger location authorization
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined) {
        // TODO: remove availability check
        if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [self.locationManager requestAlwaysAuthorization]; // "Always" needed for significant location change
        }
    }

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.locationManager startMonitoringSignificantLocationChanges];  // TODO: reconsider accuracy
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.locationManager stopMonitoringSignificantLocationChanges];
}

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    
    // Redirect datasource
    self.tableView.dataSource = self.fetchedResultsControllerDataSource;

    // Pass MOC on to favourite view
    self.headerView.managedObjectContext = self.managedObjectContext;
}


#pragma mark - User interaction

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showMensaDetail"]) {
        UHDMensaDetailViewController *detailVC = segue.destinationViewController;
        UITableViewCell *cell = [self cellForSubview:sender];
        detailVC.mensa = [self.fetchedResultsControllerDataSource.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForCell:cell]];
    } else if ([segue.identifier isEqualToString:@"selectMensa"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@([(UHDMensa *)self.fetchedResultsControllerDataSource.selectedItem remoteObjectId]) forKey:UHDUserDefaultsKeySelectedMensaId];
    }
}

-(UITableViewCell *)cellForSubview:(id)theView
{
    id viewSuperView = [theView superview];
    while (viewSuperView != nil) {
        if ([viewSuperView isKindOfClass:[UITableViewCell class]]) {
            return (UITableViewCell *)viewSuperView;
        } else {
            viewSuperView = [viewSuperView superview];
        }
    }
    return nil;
}

- (IBAction)sortControlValueChanged:(id)sender
{
    NSArray *sortDescriptors = nil;
    switch (self.sortControl.selectedSegmentIndex) {
        case 0:
            sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES] ];
            break;
        case 1:
            sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"currentDistance" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES] ];
            break;
        default:
            break;
    }
    self.fetchedResultsControllerDataSource.fetchedResultsController.fetchRequest.sortDescriptors = sortDescriptors;
    [self.fetchedResultsControllerDataSource reloadData];
}

- (IBAction)refreshControlValueChanged:(UIRefreshControl *)sender
{
    [[[UHDRemoteDatasourceManager defaultManager] remoteDatasourceForKey:UHDRemoteDatasourceKeyMensa] refreshWithCompletion:^(BOOL success, NSError *error) {
        [sender endRefreshing];
    }];
}

#pragma mark - Table View Datasource

- (VIFetchedResultsControllerDataSource *)fetchedResultsControllerDataSource {
    if (!_fetchedResultsControllerDataSource && self.managedObjectContext) {
        
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[UHDMensa entityName]];
        fetchRequest.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES] ];

        NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];

        __weak UHDMensaListViewController *weakSelf = self;
        VITableViewCellConfigureBlock configureCellBlock = ^(UITableViewCell *cell, id item) {
            [(UHDMensaCell *)cell configureForMensa:(UHDMensa *)item];
            [(UHDMensaCell *)cell setDelegate:weakSelf];
        };
        
        self.fetchedResultsControllerDataSource = [[VIFetchedResultsControllerDataSource alloc] initWithFetchedResultsController:fetchedResultsController tableView:self.tableView cellIdentifier:@"mensaCell" configureCellBlock:configureCellBlock];
        
    }
    return _fetchedResultsControllerDataSource;
}


#pragma mark - Swipe Table View Cell Delegate

-(void)swipeTableViewCellDidStartSwiping:(RMSwipeTableViewCell *)swipeTableViewCell {
    [self.logger log:@"swipeTableViewCellDidStartSwiping: %@" object:swipeTableViewCell forLevel:VILogLevelVerbose];
}

-(void)swipeTableViewCell:(UHDMensaCell *)swipeTableViewCell didSwipeToPoint:(CGPoint)point velocity:(CGPoint)velocity {
    [self.logger log:[NSString stringWithFormat:@"swipeTableViewCell: %@ didSwipeToPoint: %@ velocity: %@", swipeTableViewCell, NSStringFromCGPoint(point), NSStringFromCGPoint(velocity)] forLevel:VILogLevelVerbose];
}

-(void)swipeTableViewCellWillResetState:(RMSwipeTableViewCell *)swipeTableViewCell fromPoint:(CGPoint)point animation:(RMSwipeTableViewCellAnimationType)animation velocity:(CGPoint)velocity
{
    [self.logger log:[NSString stringWithFormat:@"swipeTableViewCellWillResetState: %@ fromPoint: %@ animation: %u, velocity: %@", swipeTableViewCell, NSStringFromCGPoint(point), animation, NSStringFromCGPoint(velocity)] forLevel:VILogLevelVerbose];
    
    if ([(UHDFavouriteCell *)swipeTableViewCell shouldTriggerForPoint:point]) {
        UHDMensa *mensa = [self.fetchedResultsControllerDataSource.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForCell:swipeTableViewCell]];
        
        mensa.isFavourite = !mensa.isFavourite;
        [mensa.managedObjectContext saveToPersistentStore:nil];
    }
}

-(void)swipeTableViewCellDidResetState:(RMSwipeTableViewCell *)swipeTableViewCell fromPoint:(CGPoint)point animation:(RMSwipeTableViewCellAnimationType)animation velocity:(CGPoint)velocity {
    [self.logger log:[NSString stringWithFormat:@"swipeTableViewCellDidResetState: %@ fromPoint: %@ animation: %u, velocity: %@", swipeTableViewCell, NSStringFromCGPoint(point), animation, NSStringFromCGPoint(velocity)] forLevel:VILogLevelVerbose];
}


#pragma mark - CLLocationManager Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    for (UHDMensa *mensa in self.fetchedResultsControllerDataSource.fetchedResultsController.fetchedObjects) {
        mensa.currentDistance = [mensa.location distanceFromLocation:locations.lastObject];
    }
    //[self.tableView reloadRowsAtIndexPaths:self.tableView.indexPathsForVisibleRows withRowAnimation:UITableViewRowAnimationNone];
}

- (void)locationManager:(CLLocationManager *)manager
      didFailWithError:(NSError *)error
{
    for (UHDMensa *mensa in self.fetchedResultsControllerDataSource.fetchedResultsController.fetchedObjects) {
        mensa.currentDistance = -1;
    }
    //[self.tableView reloadRowsAtIndexPaths:self.tableView.indexPathsForVisibleRows withRowAnimation:UITableViewRowAnimationNone];
}

@end
