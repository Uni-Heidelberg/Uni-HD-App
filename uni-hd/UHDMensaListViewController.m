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

@interface UHDMensaListViewController () <RMSwipeTableViewCellDelegate, CLLocationManagerDelegate, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSFetchedResultsController *favouritesResultsController;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) UILabel *sectionHeaderLabel1;
@property (strong, nonatomic) UILabel *sectionHeaderLabel2;




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
    
}


#pragma mark - User interaction

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showMensaDetail"]) {
        UHDMensaDetailViewController *detailVC = segue.destinationViewController;
        UITableViewCell *cell = [self cellForSubview:sender];
        detailVC.mensa = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForCell:cell]];
    } else if ([segue.identifier isEqualToString:@"selectMensa"]) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@([(UHDMensa *)[self mensaForIndexPath:self.tableView.indexPathForSelectedRow] remoteObjectId]) forKey:UHDUserDefaultsKeySelectedMensaId];
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
    self.fetchedResultsController.fetchRequest.sortDescriptors = sortDescriptors;
    //[self.fetchedResultsControllerDataSource reloadData];
}

- (IBAction)refreshControlValueChanged:(UIRefreshControl *)sender
{
    [[[UHDRemoteDatasourceManager defaultManager] remoteDatasourceForKey:UHDRemoteDatasourceKeyMensa] refreshWithCompletion:^(BOOL success, NSError *error) {
        [sender endRefreshing];
    }];
}

-(void)updateSectionHeaders{
    NSArray *list;
    list = [NSArray arrayWithObjects:
            @"Favoriten",
            @"weitere Mensen",nil];
    
    NSString *string1 =[list objectAtIndex:0];
    [self.sectionHeaderLabel1 setText:string1];
    NSString *string2 =[list objectAtIndex:1];
    [self.sectionHeaderLabel2 setText:string2];
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    /* Create custom view to display section header... */
    if (section == 0) {
        self.sectionHeaderLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 18)];
        [self.sectionHeaderLabel1 setFont:[UIFont boldSystemFontOfSize:12]];
        [view addSubview:self.sectionHeaderLabel1];
    }
    else if (section == 1) {
        self.sectionHeaderLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 18)];
        [self.sectionHeaderLabel2 setFont:[UIFont boldSystemFontOfSize:12]];
        [view addSubview:self.sectionHeaderLabel2];
    }
    [view setBackgroundColor:[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0]]; //your background color...
    [self updateSectionHeaders];
    
    return view;
}

#pragma mark - Table View Datasource

- (NSFetchedResultsController *)fetchedResultsController {
    if (!_fetchedResultsController && self.managedObjectContext) {
        
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[UHDMensa entityName]];
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
        
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        _fetchedResultsController.delegate = self;
        [_fetchedResultsController performFetch:nil];
        
    }
    return _fetchedResultsController;
}
- (NSFetchedResultsController *)favouritesResultsController {
    if (!_favouritesResultsController && self.managedObjectContext) {
        
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[UHDMensa entityName]];
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"remoteObjectId" ascending:YES]];
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"isFavourite == 1"];
        //TODO: sortdescriptor im model
        
        _favouritesResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath: @"isFavourite" cacheName:nil];
        _favouritesResultsController.delegate = self;
        [_favouritesResultsController performFetch:nil];
        
        
    }
    return _favouritesResultsController;
}

#pragma mark - Table View Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    if (sectionIndex==0) {
        return self.favouritesResultsController.fetchedObjects.count;
    }
    else  {
        return self.fetchedResultsController.fetchedObjects.count;
    }
}
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    id cell = [tableView dequeueReusableCellWithIdentifier:@"mensaCell"  forIndexPath:indexPath];
    id object;
    if (indexPath.section==0){
        object = [self.favouritesResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
    }
    else if (indexPath.section==1){
        object = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
    }
    [(UHDMensaCell *)cell configureForMensa:(UHDMensa *)object];
    [(UHDMensaCell *)cell setDelegate:self];
    return cell;
    
}
- (UHDMensa*)mensaForIndexPath:(NSIndexPath*)indexPath{
    id object;
    if (indexPath.section==0){
        object = [self.favouritesResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
    }
    else {
        object = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
    }
    return object;
}

#pragma mark NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController*)controller
{
    [self.logger log:@"Begin updates" forLevel:VILogLevelVerbose];
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController*)controller
{
    [self.logger log:@"End updates" forLevel:VILogLevelVerbose];
    [self.tableView endUpdates];
}


- (void)controller:(NSFetchedResultsController*)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath*)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath*)newIndexPath
{
    if (controller==self.fetchedResultsController){
        indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:1];
        newIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:1];
    }
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[ newIndexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.logger log:@"Inserted row at index path" object:newIndexPath forLevel:VILogLevelVerbose];
            break;
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView insertRowsAtIndexPaths:@[ newIndexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.logger log:@"Moved row at index path" object:indexPath forLevel:VILogLevelVerbose];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.logger log:@"Deleted row at index path" object:indexPath forLevel:VILogLevelVerbose];
            break;
        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.logger log:@"Updated row at index path" object:indexPath forLevel:VILogLevelVerbose];
            break;
        default:
            break;
    }
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
        UHDMensa *mensa = [self mensaForIndexPath:[self.tableView indexPathForCell:swipeTableViewCell]];
        mensa.isFavourite = !mensa.isFavourite;
        [mensa.managedObjectContext saveToPersistentStore:nil];
        [self updateSectionHeaders];
    }
}

-(void)swipeTableViewCellDidResetState:(RMSwipeTableViewCell *)swipeTableViewCell fromPoint:(CGPoint)point animation:(RMSwipeTableViewCellAnimationType)animation velocity:(CGPoint)velocity {
    [self.logger log:[NSString stringWithFormat:@"swipeTableViewCellDidResetState: %@ fromPoint: %@ animation: %u, velocity: %@", swipeTableViewCell, NSStringFromCGPoint(point), animation, NSStringFromCGPoint(velocity)] forLevel:VILogLevelVerbose];
}


#pragma mark - CLLocationManager Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    for (UHDMensa *mensa in self.fetchedResultsController.fetchedObjects) {
        mensa.currentDistance = [mensa.location distanceFromLocation:locations.lastObject];
    }
}


- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    for (UHDMensa *mensa in self.fetchedResultsController.fetchedObjects) {
        mensa.currentDistance = -1;
    }
}

@end
