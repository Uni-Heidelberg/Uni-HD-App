//
//  UHDMensaListViewController.m
//  uni-hd
//
//  Created by Felix on 07.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDMensaListViewController.h"
#import "NSManagedObject+VIInsertIntoContextCategory.h"
#import "VILogger.h"

// Table View Datasource
#import "VIFetchedResultsControllerDataSource.h"

// View Controller
#import "UHDMensaViewController.h"

// View
#import "UHDMensaCell.h"
#import "UHDMensaSectionHeaderView.h"

// Swift
#import <UHDKit/UHDKit-Swift.h>

@interface UHDMensaListViewController () <RMSwipeTableViewCellDelegate, CLLocationManagerDelegate, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSFetchedResultsController *favouritesResultsController;

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
    [self.tableView registerNib:[UINib nibWithNibName:@"UHDMensaSectionHeaderView" bundle:[NSBundle bundleForClass:[self class]]] forHeaderFooterViewReuseIdentifier:@"TableHeader"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.locationManager startMonitoringSignificantLocationChanges];  // TODO: reconsider accuracy
    if ([self indexPathOfSelectedMensa]==nil) {
        [self.logger log:@"No Mensa selected" forLevel:VILogLevelDebug];
    }
    else {
        [self.tableView selectRowAtIndexPath: [self indexPathOfSelectedMensa] animated:animated scrollPosition:UITableViewScrollPositionNone];
    }
    
}
-(NSIndexPath *)indexPathOfSelectedMensa{
    [self.logger log:@"Loading selected mensa from user defaults..." forLevel:VILogLevelDebug];
    
    NSNumber *mensaId = [[NSUserDefaults standardUserDefaults] objectForKey:[UHDConstants userDefaultsKeySelectedMensaId]];
    if (!mensaId) {
    }
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[Mensa entityName]];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"remoteObjectId == %@", mensaId];
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:NULL];
    if (result.count > 0) {
        Mensa *selectedMensa = result.firstObject;
        [self.logger log:@"Found selected Mensa." object:selectedMensa.title forLevel:VILogLevelDebug];
        return [self indexPathForMensa:selectedMensa];
    } else {
        [self.logger log:@"Selected invalid mensa." forLevel:VILogLevelError];
        return nil;
    }
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
    if ([segue.identifier isEqualToString:@"selectMensa"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@([(Mensa *)[self mensaForIndexPath:self.tableView.indexPathForSelectedRow] remoteObjectId]) forKey:[UHDConstants userDefaultsKeySelectedMensaId]];
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
            sortDescriptors = @[ /*[NSSortDescriptor sortDescriptorWithKey:@"managedCurrentDistance" ascending:YES],*/ [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES] ]; // TODO: implement distance again
            break;
        default:
            break;
    }
    self.fetchedResultsController.fetchRequest.sortDescriptors = sortDescriptors;
    [self.fetchedResultsController performFetch:nil];
    [self.tableView reloadData];
    [self.tableView selectRowAtIndexPath: [self indexPathOfSelectedMensa] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (IBAction)refreshControlValueChanged:(UIRefreshControl *)sender
{
    [[[UHDRemoteDatasourceManager defaultManager] remoteDatasourceForKey:[UHDConstants remoteDatasourceKeyMensa]] refreshWithCompletion:^(BOOL success, NSError *error) {
        [sender endRefreshing];
    }];
}

- (IBAction)detailButtonPressed:(id)sender
{
    InstitutionDetailViewController *detailVC = [[UIStoryboard storyboardWithName:@"campus" bundle:[NSBundle bundleForClass:[self class]]] instantiateViewControllerWithIdentifier:@"institutionDetail"];
    UITableViewCell *cell = [self cellForSubview:sender];
    detailVC.institution = [self mensaForIndexPath:[self.tableView indexPathForCell:cell]];
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - Fetched Results Controller Setup

- (NSFetchedResultsController *)fetchedResultsController {
    if (!_fetchedResultsController && self.managedObjectContext) {
        
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[Mensa entityName]];
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
        
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        _fetchedResultsController.delegate = self;
        [_fetchedResultsController performFetch:nil];
        
    }
    return _fetchedResultsController;
}
- (NSFetchedResultsController *)favouritesResultsController {
    if (!_favouritesResultsController && self.managedObjectContext) {
        
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[Mensa entityName]];
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"remoteObjectId" ascending:YES]];
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"isFavourite == 1"];
        //TODO: sortdescriptor im model
        
        _favouritesResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath: @"isFavourite" cacheName:nil];
        _favouritesResultsController.delegate = self;
        [_favouritesResultsController performFetch:nil];
        
        
    }
    return _favouritesResultsController;
}


#pragma mark - Table View Datasource

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
    [(UHDMensaCell *)cell configureForMensa:(Mensa *)object];
    [(UHDMensaCell *)cell setDelegate:self];
    return cell;
    
}

- (Mensa *)mensaForIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section==0){
        return [self.favouritesResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
    } else {
        return [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
    }
    return nil;
}
- (NSIndexPath *)indexPathForMensa:(Mensa *)mensa
{
    if (mensa == 0) {
        [self.logger log:@"No Mensa selected." forLevel:VILogLevelDebug];
        return nil;
    } else {
        NSIndexPath *oldIndexPath = [self.fetchedResultsController indexPathForObject:mensa];
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:oldIndexPath.row inSection:oldIndexPath.section+1];
        return newIndexPath;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==0 && self.favouritesResultsController.fetchedObjects.count == 0){
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 45)];
        UILabel *footerLabel = [[UILabel alloc] initWithFrame:view.bounds];
        footerLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        footerLabel.textAlignment = NSTextAlignmentCenter;
        footerLabel.text = [NSString stringWithFormat:@"Swipe Mensa to mark as favourite."];
        footerLabel.font = [UIFont systemFontOfSize:14];
        footerLabel.textColor = [UIColor lightGrayColor];
        [view addSubview:footerLabel];
        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0 && self.favouritesResultsController.fetchedObjects.count == 0){
        return 60;
        
    }
    else{
        return 0.0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 24;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UHDMensaSectionHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"TableHeader"];
    if (section == 0) {
        header.sectionHeaderLabel.text=[NSString stringWithFormat:NSLocalizedString(@"Favoriten", nil)];
        if (self.favouritesResultsController.fetchedObjects.count == 0) {
           // header.mensenButton.enabled = NO; TODO: make dynamic
        }
        else {
           // header.mensenButton.enabled = YES;
        }
    }
    else {
        header.sectionHeaderLabel.text=[NSString stringWithFormat:NSLocalizedString(@"Alle Mensen", nil)];
        header.mensenButton.hidden = true;
    }
    return header;
}


#pragma mark Fetched Results Controller Delegate

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
    [self.logger log:[NSString stringWithFormat:@"swipeTableViewCellWillResetState: %@ fromPoint: %@ animation: %lu, velocity: %@", swipeTableViewCell, NSStringFromCGPoint(point), animation, NSStringFromCGPoint(velocity)] forLevel:VILogLevelVerbose];
    
    if ([(UHDFavouriteCell *)swipeTableViewCell shouldTriggerForPoint:point]) {
        Mensa *mensa = [self mensaForIndexPath:[self.tableView indexPathForCell:swipeTableViewCell]];
        mensa.isFavourite = !mensa.isFavourite;
        [mensa.managedObjectContext saveToPersistentStore:nil];
    }
}

-(void)swipeTableViewCellDidResetState:(RMSwipeTableViewCell *)swipeTableViewCell fromPoint:(CGPoint)point animation:(RMSwipeTableViewCellAnimationType)animation velocity:(CGPoint)velocity {
    [self.logger log:[NSString stringWithFormat:@"swipeTableViewCellDidResetState: %@ fromPoint: %@ animation: %lu, velocity: %@", swipeTableViewCell, NSStringFromCGPoint(point), animation, NSStringFromCGPoint(velocity)] forLevel:VILogLevelVerbose];
}


#pragma mark - Location Manager Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [self.logger log:@"Received location update." object:locations forLevel:VILogLevelDebug];
    for (Mensa *mensa in self.fetchedResultsController.fetchedObjects) {
        mensa.location.managedCurrentDistance = [NSNumber numberWithDouble:[[[CLLocation alloc] initWithLatitude:mensa.location.coordinate.latitude longitude:mensa.location.coordinate.longitude] distanceFromLocation:locations.lastObject]];
    }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    [self.logger log:@"Failed to receive location update." forLevel:VILogLevelDebug];
    for (Mensa *mensa in self.fetchedResultsController.fetchedObjects) {
        mensa.location.managedCurrentDistance = @(-1);
    }
}


@end
