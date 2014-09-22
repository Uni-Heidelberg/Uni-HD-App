//
//  UHDMapsViewController.m
//  uni-hd
//
//  Created by Nils Fischer on 22.06.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDMapsViewController.h"
#import "UHDRemoteDatasourceManager.h"

// Model
#import "UHDBuilding.h"
#import "UHDCampusRegion.h"

// View Controllers
#import "UHDMapsSearchTableViewController.h"
#import "UHDBuildingDetailViewController.h"

//View
#import "VIImageOverlayRenderer.h"
#import "UHDBuildingAnnotationView.h"


@interface UHDMapsViewController () <MKMapViewDelegate, NSFetchedResultsControllerDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSFetchedResultsController *campusRegionsFetchedResultsController;

- (IBAction)unwindToMap:(UIStoryboardSegue *)segue;

@end


@implementation UHDMapsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // trigger location authorization
    // TODO: inform user first
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    self.locationManager = locationManager;
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined) {
        if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [locationManager requestWhenInUseAuthorization];
        }
    }

    
    // Configure UI
    
    UIBarButtonItem *trackingButton = [[MKUserTrackingBarButtonItem alloc] initWithMapView:self.mapView];
    self.navigationItem.leftBarButtonItem = trackingButton;
    
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    self.navigationItem.titleView = searchBar;

    
    // Register Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDefaultsDidChange:) name:NSUserDefaultsDidChangeNotification object:[NSUserDefaults standardUserDefaults]];
    
    [self configureView];

}

- (void)configureView
{
    // Configure map view
    if ([[NSUserDefaults standardUserDefaults] objectForKey:UHDUserDefaultsKeyMapType]) {
        self.mapView.mapType = [[[NSUserDefaults standardUserDefaults] objectForKey:UHDUserDefaultsKeyMapType] unsignedIntegerValue];
    } else {
        self.mapView.mapType = MKMapTypeStandard;
    }
    
    // Add overlays
    NSArray *allCampusRegions = self.campusRegionsFetchedResultsController.fetchedObjects;
    [self.mapView removeOverlays:allCampusRegions];
    if (![[NSUserDefaults standardUserDefaults] objectForKey:UHDUserDefaultsKeyShowCampusOverlay] || [[[NSUserDefaults standardUserDefaults] objectForKey:UHDUserDefaultsKeyShowCampusOverlay] boolValue]) {
        [self.mapView addOverlays:allCampusRegions];
    }
    
    // Add all annotations
    NSArray *allBuildings = self.fetchedResultsController.fetchedObjects;
    [self.mapView removeAnnotations:allBuildings];
    [self.mapView showAnnotations:allBuildings animated:YES];
}

- (NSFetchedResultsController *)campusRegionsFetchedResultsController{
    
    if(!_campusRegionsFetchedResultsController){
        
        NSFetchRequest *theRequest = [NSFetchRequest fetchRequestWithEntityName:[UHDCampusRegion entityName]];
        theRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"remoteObjectId" ascending:YES]];
        NSFetchedResultsController *campusRegionsFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:theRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        campusRegionsFetchedResultsController.delegate = self;
        [campusRegionsFetchedResultsController performFetch:NULL];
        self.campusRegionsFetchedResultsController = campusRegionsFetchedResultsController;
        
    }
    return _campusRegionsFetchedResultsController;
}

- (NSFetchedResultsController *)fetchedResultsController {
    if (!_fetchedResultsController) {

        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[UHDBuilding entityName]];
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
        NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        fetchedResultsController.delegate = self;
        [fetchedResultsController performFetch:NULL];
        
        self.fetchedResultsController = fetchedResultsController;
    }
    return _fetchedResultsController;
}


#pragma mark - User Interaction

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showMapsSearch"]) {
        UHDMapsSearchTableViewController *mapsSearchVC = segue.destinationViewController;
        mapsSearchVC.managedObjectContext = self.managedObjectContext;
    } else if ([segue.identifier isEqualToString:@"showBuildingDetail"]) {
        [(UHDBuildingDetailViewController *)segue.destinationViewController setBuilding:(UHDBuilding *)[(MKAnnotationView *)sender annotation]];
    } else if ([segue.identifier isEqualToString:@"showMapConfiguration"]) {

    }
}

- (IBAction)unwindToMap:(UIStoryboardSegue *)segue {
    
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"showBuildingDetail" sender:view];
}


#pragma mark - Notification responses

- (void)userDefaultsDidChange:(NSNotification *)notification
{
    [self configureView];
}


#pragma mark - Map View Delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    UHDBuilding *building = (UHDBuilding *)annotation;
    NSArray *allBuildings = self.fetchedResultsController.fetchedObjects;
    
    if ([allBuildings containsObject:building]) {

        static NSString *buildingAnnotationViewIdentifier = @"buildingAnnotation";
        UHDBuildingAnnotationView *buildingAnnotationView = (UHDBuildingAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:buildingAnnotationViewIdentifier];
        if (!buildingAnnotationView) {
            buildingAnnotationView = [[UHDBuildingAnnotationView alloc] initWithAnnotation:building reuseIdentifier:buildingAnnotationViewIdentifier];
            buildingAnnotationView.canShowCallout = YES;
        } else {
            buildingAnnotationView.annotation = building;
        }
        
        return buildingAnnotationView;
    }

    return nil;
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    NSArray *allOverlays = self.campusRegionsFetchedResultsController.fetchedObjects;
    if ([allOverlays containsObject:overlay])
    {
        VIImageOverlayRenderer *renderer = [[VIImageOverlayRenderer alloc] initWithOverlay:(UHDCampusRegion *)overlay];
        renderer.opacity = 0.8;
        return renderer;
    }
    return nil;
}


#pragma mark - Fetched Results Controller Delegate

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    if (controller == self.campusRegionsFetchedResultsController) {
        switch (type) {
            case NSFetchedResultsChangeDelete:
                [self.mapView removeOverlay:anObject];
                break;
            case NSFetchedResultsChangeInsert:
                [self.mapView addOverlay:anObject];
                break;
            case NSFetchedResultsChangeUpdate:
                [self.mapView removeOverlay:anObject];
                [self.mapView addOverlay:anObject];
                break;
            case NSFetchedResultsChangeMove:
            default:
                break;
        }
    } else if (controller == self.fetchedResultsController) {
        switch (type) {
            case NSFetchedResultsChangeDelete:
                [self.mapView removeAnnotation:anObject];
                break;
            case NSFetchedResultsChangeInsert:
                [self.mapView addAnnotation:anObject];
                break;
            case NSFetchedResultsChangeUpdate:
                [self.mapView removeAnnotation:anObject];
                [self.mapView addAnnotation:anObject];
                break;
            case NSFetchedResultsChangeMove:
            default:
                break;
        }
    }
}

@end
