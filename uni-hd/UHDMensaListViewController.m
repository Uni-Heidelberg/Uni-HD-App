//
//  UHDMensaViewController.m
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

// Model
#import "UHDMensa.h"


@interface UHDMensaListViewController ()

@property (strong, nonatomic) VIFetchedResultsControllerDataSource *fetchedResultsControllerDataSource;

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
    [self.locationManager startUpdatingLocation];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.locationManager stopUpdatingLocation];

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSUserDefaults standardUserDefaults] setObject:@([(UHDMensa *)self.fetchedResultsControllerDataSource.selectedItem remoteObjectId]) forKey:UHDUserDefaultsKeySelectedMensaId];
}

#pragma mark - Table View Datasource

- (VIFetchedResultsControllerDataSource *)fetchedResultsControllerDataSource {
    if (!_fetchedResultsControllerDataSource) {
        
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[UHDMensa entityName]];
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];

        NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];

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
#pragma mark - Swipe Table View Cell Delegate

-(void)swipeTableViewCellDidStartSwiping:(RMSwipeTableViewCell *)swipeTableViewCell {
    [self.logger log:@"swipeTableViewCellDidStartSwiping: %@" object:swipeTableViewCell forLevel:VILogLevelVerbose];
}

-(void)swipeTableViewCell:(UHDMensaCell *)swipeTableViewCell didSwipeToPoint:(CGPoint)point velocity:(CGPoint)velocity {
    [self.logger log:[NSString stringWithFormat:@"swipeTableViewCell: %@ didSwipeToPoint: %@ velocity: %@", swipeTableViewCell, NSStringFromCGPoint(point), NSStringFromCGPoint(velocity)] forLevel:VILogLevelVerbose];
}

-(void)swipeTableViewCellWillResetState:(RMSwipeTableViewCell *)swipeTableViewCell fromPoint:(CGPoint)point animation:(RMSwipeTableViewCellAnimationType)animation velocity:(CGPoint)velocity {
    [self.logger log:[NSString stringWithFormat:@"swipeTableViewCellWillResetState: %@ fromPoint: %@ animation: %lu, velocity: %@", swipeTableViewCell, NSStringFromCGPoint(point), animation, NSStringFromCGPoint(velocity)] forLevel:VILogLevelVerbose];
    if (-point.x >= CGRectGetHeight(swipeTableViewCell.frame)) {
        if (((UHDMensaCell *)swipeTableViewCell).mensa.isFavourite) {
            ((UHDMensaCell *)swipeTableViewCell).mensa.isFavourite = NO;
        } else {
            ((UHDMensaCell *)swipeTableViewCell).mensa.isFavourite = YES;
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
