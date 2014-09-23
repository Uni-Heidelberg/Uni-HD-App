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
#import "UHDMensaCell+ConfigureForItem.h"
#import "UHDFavouriteMensaCell.h"

// Model
#import "UHDMensa.h"


@interface UHDMensaListViewController ()

@property (strong, nonatomic) VIFetchedResultsControllerDataSource *fetchedResultsControllerDataSource;
@property   NSFetchRequest *fetchRequest;
@property UHDFavouriteMensaCell *favouriteCell;
- (IBAction)segmentedControlPressed:(id)sender;
- (IBAction)refreshControlValueChanged:(id)sender;

@end


@implementation UHDMensaListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // redirect datasource
    self.tableView.dataSource = self.fetchedResultsControllerDataSource;
    
    //create instance of CLLocationManager
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
    // trigger location authorization
    // TODO: inform user first
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined) {
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
    }
    [self.locationManager startMonitoringSignificantLocationChanges];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.locationManager stopMonitoringSignificantLocationChanges];

}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:[NSString stringWithFormat:@"showMensaDetail"]]) {
        UHDMensaDetailViewController *detailVC = [segue destinationViewController];
        UITableViewCell *owningCell = [self parentCellForView:sender];
        detailVC.mensa = [self.fetchedResultsControllerDataSource.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForCell:owningCell]];
    }
}
-(UITableViewCell *)parentCellForView:(id)theView
{
    id viewSuperView = [theView superview];
    while (viewSuperView != nil) {
        if ([viewSuperView isKindOfClass:[UITableViewCell class]]) {
            return (UITableViewCell *)viewSuperView;
        }
        else {
            viewSuperView = [viewSuperView superview];
        }
    }
    return nil;
}

#pragma mark - User Interaction

- (IBAction)segmentedControlPressed:(id)sender{
    if( ((UISegmentedControl *)sender).selectedSegmentIndex == 0){
        self.fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
    }
    else if (((UISegmentedControl *)sender).selectedSegmentIndex == 1){
        self.fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"currentDistanceInKm" ascending:YES]];
    }
    
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:self.fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    VITableViewCellConfigureBlock configureCellBlock = ^(UITableViewCell *cell, id item) {
        ((UHDMensaCell *)cell).mensa = (UHDMensa *)item;
        [(UHDMensaCell *)cell configureForMensa:(UHDMensa *)item];
        __weak UHDMensaListViewController *weakSelf = self;
        [(UHDMensaCell *)cell setDelegate: weakSelf];
    };
    self.fetchedResultsControllerDataSource = [[VIFetchedResultsControllerDataSource alloc] initWithFetchedResultsController:fetchedResultsController tableView:self.tableView cellIdentifier:@"mensaCell" configureCellBlock:configureCellBlock];
    [self.tableView reloadData];
}

- (IBAction)refreshControlValueChanged:(id)sender {
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSUserDefaults standardUserDefaults] setObject:@([(UHDMensa *)self.fetchedResultsControllerDataSource.selectedItem remoteObjectId]) forKey:UHDUserDefaultsKeySelectedMensaId];
}

#pragma mark - Table View Datasource

- (VIFetchedResultsControllerDataSource *)fetchedResultsControllerDataSource {
    if (!_fetchedResultsControllerDataSource) {
        
        self.fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[UHDMensa entityName]];
        self.fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];

        NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:self.fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];

        VITableViewCellConfigureBlock configureCellBlock = ^(UITableViewCell *cell, id item) {
            ((UHDMensaCell *)cell).mensa = (UHDMensa *)item;
            [(UHDMensaCell *)cell configureForMensa:(UHDMensa *)item];
            __weak UHDMensaListViewController *weakSelf = self;
            [(UHDMensaCell *)cell setDelegate: weakSelf];
        };
        
        self.fetchedResultsControllerDataSource = [[VIFetchedResultsControllerDataSource alloc] initWithFetchedResultsController:fetchedResultsController tableView:self.tableView cellIdentifier:@"mensaCell" configureCellBlock:configureCellBlock];
        
    }
    return _fetchedResultsControllerDataSource;
}

- (IBAction)segementedControlPressed:(id)sender {
}
#pragma mark - Swipe Table View Cell Delegate

-(void)swipeTableViewCellDidStartSwiping:(RMSwipeTableViewCell *)swipeTableViewCell {
    [self.logger log:@"swipeTableViewCellDidStartSwiping: %@" object:swipeTableViewCell forLevel:VILogLevelVerbose];
}

-(void)swipeTableViewCell:(UHDMensaCell *)swipeTableViewCell didSwipeToPoint:(CGPoint)point velocity:(CGPoint)velocity {
    [self.logger log:[NSString stringWithFormat:@"swipeTableViewCell: %@ didSwipeToPoint: %@ velocity: %@", swipeTableViewCell, NSStringFromCGPoint(point), NSStringFromCGPoint(velocity)] forLevel:VILogLevelVerbose];
}

-(void)swipeTableViewCellWillResetState:(RMSwipeTableViewCell *)swipeTableViewCell fromPoint:(CGPoint)point animation:(RMSwipeTableViewCellAnimationType)animation velocity:(CGPoint)velocity {
    [self.logger log:[NSString stringWithFormat:@"swipeTableViewCellWillResetState: %@ fromPoint: %@ animation: %u, velocity: %@", swipeTableViewCell, NSStringFromCGPoint(point), animation, NSStringFromCGPoint(velocity)] forLevel:VILogLevelVerbose];
    if (-point.x >= CGRectGetHeight(swipeTableViewCell.frame)) {
        if (((UHDMensaCell *)swipeTableViewCell).mensa.isFavourite) {
            ((UHDMensaCell *)swipeTableViewCell).mensa.isFavourite = NO;
        } else {
            ((UHDMensaCell *)swipeTableViewCell).mensa.isFavourite = YES;
            if (self.favouriteCell==nil) {
                self.favouriteCell = [[UHDFavouriteMensaCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"favouriteCell"];
            }
            [self.favouriteCell addFavouriteMensa:((UHDMensaCell *)swipeTableViewCell).mensa];
        }
        [(UHDMensaCell *)swipeTableViewCell setFavourite:((UHDMensaCell *)swipeTableViewCell).mensa.isFavourite animated:YES];
    }

}

-(void)swipeTableViewCellDidResetState:(RMSwipeTableViewCell *)swipeTableViewCell fromPoint:(CGPoint)point animation:(RMSwipeTableViewCellAnimationType)animation velocity:(CGPoint)velocity {
    [self.logger log:[NSString stringWithFormat:@"swipeTableViewCellDidResetState: %@ fromPoint: %@ animation: %lu, velocity: %@", swipeTableViewCell, NSStringFromCGPoint(point), animation, NSStringFromCGPoint(velocity)] forLevel:VILogLevelVerbose];
}
#pragma mark - CLLocationManager Delegate


-(void)locationManager:(CLLocationManager *)manager
   didUpdateToLocation:(CLLocation *)newLocation
          fromLocation:(CLLocation *)oldLocation
{
    int k = [self.tableView numberOfRowsInSection:0];

    for (int i=0; i<k; i++) {
        UHDMensaCell *cell = (UHDMensaCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        [cell calculateDistanceWith: newLocation];
    }
}

-(void)locationManager:(CLLocationManager *)manager
      didFailWithError:(NSError *)error
{
}
@end
