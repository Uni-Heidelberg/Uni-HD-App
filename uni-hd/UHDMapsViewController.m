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
#import "UHDMapsSearchResultsViewController.h"


//View
#import "VIImageOverlayRenderer.h"
#import "UHDBuildingAnnotationView.h"


@interface UHDMapsViewController () <MKMapViewDelegate, NSFetchedResultsControllerDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate, UISearchControllerDelegate, UHDMapsSearchResultsViewControllerDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) UHDMapsSearchResultsViewController *searchResultsViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSFetchedResultsController *campusRegionsFetchedResultsController;
//@property (strong, nonatomic) IBOutlet UISearchBar *mapsSearchBar;
//@property (strong, nonatomic) UITapGestureRecognizer *tapSearchBar;

@property (strong, nonatomic) UISearchController *searchController;

@property (weak, nonatomic) id<MKAnnotation> selectedAnnotation;

@property (nonatomic) BOOL isAdjustingToValidMapRegion;
@property (nonatomic) MKCoordinateRegion lastValidMapRegion;

- (IBAction)unwindToMap:(UIStoryboardSegue *)segue;

@end


@implementation UHDMapsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self.navigationController.tabBarItem setSelectedImage:[UIImage imageNamed:@"mapsIconSelected"]];
    
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
    
    // Add tracking button
    UIBarButtonItem *trackingButton = [[MKUserTrackingBarButtonItem alloc] initWithMapView:self.mapView];
    self.navigationItem.leftBarButtonItem = trackingButton;
    
    // Add Search Bar & Controller
    UHDMapsSearchResultsViewController *searchResultsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"searchResults"];
    searchResultsViewController.delegate = self;
    searchResultsViewController.managedObjectContext = self.managedObjectContext;
    self.searchResultsViewController = searchResultsViewController;
    UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:searchResultsViewController];
    searchController.searchResultsUpdater = searchResultsViewController;
    searchController.delegate = self;
    searchController.hidesNavigationBarDuringPresentation = NO;
    searchController.dimsBackgroundDuringPresentation = NO;
    self.navigationItem.titleView = searchController.searchBar;
    self.searchController = searchController;
    self.definesPresentationContext = YES;
    
    // Register Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDefaultsDidChange:) name:NSUserDefaultsDidChangeNotification object:[NSUserDefaults standardUserDefaults]];
    
    // Add Tap Gesture Recognizer
    UITapGestureRecognizer *mapViewTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapOnMapView:)];
    mapViewTapGestureRecognizer.delegate = self;
    [self.mapView addGestureRecognizer:mapViewTapGestureRecognizer];
    // Make sure double-taps don't trigger the single tap gesture recognizer
    UITapGestureRecognizer *mapViewDoubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] init];
    mapViewDoubleTapGestureRecognizer.numberOfTapsRequired = 2;
    mapViewDoubleTapGestureRecognizer.delegate = self;
    [self.mapView addGestureRecognizer:mapViewDoubleTapGestureRecognizer];
    [mapViewTapGestureRecognizer requireGestureRecognizerToFail:mapViewDoubleTapGestureRecognizer];
    
    
    // Show appropriate region
    // TODO: limit scrolling to max region
    self.mapView.region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(49.4085, 8.68685), 5000, 5000);
    
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
    
    // Add campus region overlays
    NSArray *allCampusRegions = self.campusRegionsFetchedResultsController.fetchedObjects;
    [self.mapView removeOverlays:allCampusRegions];
    if (![[NSUserDefaults standardUserDefaults] objectForKey:UHDUserDefaultsKeyShowCampusOverlay] || [[NSUserDefaults standardUserDefaults] boolForKey:UHDUserDefaultsKeyShowCampusOverlay]) {
        [self.mapView addOverlays:allCampusRegions level:MKOverlayLevelAboveLabels];
    }
    
    // Add building overlays to verify their map rect
    /*NSArray *allBuildings = self.fetchedResultsController.fetchedObjects;
     [self.mapView removeOverlays:allBuildings];
     [self.mapView addOverlays:allBuildings];*/
    // Add building annotations for testing purposes
    /*NSArray *allBuildings = self.fetchedResultsController.fetchedObjects;
     [self.mapView removeAnnotations:allBuildings];
     [self.mapView addAnnotations:allBuildings];*/
    
    if (self.selectedAnnotation) {
        [self.mapView addAnnotation:self.selectedAnnotation];
        [self.mapView showAnnotations:@[ self.selectedAnnotation ] animated:NO];
        [self.mapView selectAnnotation:self.selectedAnnotation animated:NO];
    }
    
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
    if ([segue.identifier isEqualToString:@"showBuildingDetail"]) {
        [(UHDBuildingDetailViewController *)segue.destinationViewController setBuilding:(UHDBuilding *)[(MKAnnotationView *)sender annotation]];
    } else if ([segue.identifier isEqualToString:@"showMapConfiguration"]) {
        
    }
}

- (void)searchResultsViewController:(UHDMapsSearchResultsViewController *)viewController didSelectBuilding:(UHDBuilding *)building
{
    [self showLocation:building animated:YES];
}

- (void)showLocation:(UHDRemoteManagedLocation *)location animated:(BOOL)animated {
    [self.searchController setActive:NO];
    [self.mapView removeAnnotation:self.selectedAnnotation];
    self.selectedAnnotation = location;
    [self.mapView showAnnotations:@[ location ] animated:animated];
    [self.mapView selectAnnotation:location animated:animated];
}

- (IBAction)unwindToMap:(UIStoryboardSegue *)segue {
    
}

- (IBAction)showMapsSearchViewController:(id)sender {
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"showBuildingDetail" sender:view];
}

- (void)handleTapOnMapView:(UITapGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state==UIGestureRecognizerStateEnded) {
        
        id<MKAnnotation> selectedAnnotation = self.selectedAnnotation;
        self.selectedAnnotation = nil;
        [self.mapView removeAnnotation:selectedAnnotation];
        
        CLLocationCoordinate2D coordinate = [self.mapView convertPoint:[gestureRecognizer locationInView:self.mapView] toCoordinateFromView:self.mapView];
        for (UHDBuilding *building in self.fetchedResultsController.fetchedObjects) {
            if (MKMapRectContainsPoint([building boundingMapRect], MKMapPointForCoordinate(coordinate))) {
                // Tapped on building
                // Continue for already annotated buildings
                if ([self.mapView.annotations containsObject:building]) continue;
                // Present (empty) annotation with callout
                self.selectedAnnotation = building;
                [self.mapView addAnnotation:building];
                [self.mapView selectAnnotation:building animated:YES];
            }
        }
    }
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
        buildingAnnotationView.shouldHideImage = YES;
        return buildingAnnotationView;
    }
    
    return nil;
}

/*- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    // TODO: Only necessary because selection is strangely cleared right after tap occured
    if (self.selectedAnnotation && view.annotation == self.selectedAnnotation) {
        [mapView selectAnnotation:view.annotation animated:NO];
    }
}*/

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    NSArray *allCampusRegions = self.campusRegionsFetchedResultsController.fetchedObjects;
    NSArray *allBuildings = self.fetchedResultsController.fetchedObjects;
    if ([allCampusRegions containsObject:overlay]) {
        
        return [[CampusRegionOverlayRenderer alloc] initWithCampusRegion:(UHDCampusRegion *)overlay];
        
    } else if ([allBuildings containsObject:overlay]) {
        // Show the building's map rect for testing purposes
        MKMapRect boundingMapRect = [overlay boundingMapRect];
        MKMapPoint polygonPoints[4] = {
            boundingMapRect.origin,
            MKMapPointMake(boundingMapRect.origin.x + boundingMapRect.size.width, boundingMapRect.origin.y),
            MKMapPointMake(boundingMapRect.origin.x + boundingMapRect.size.width, boundingMapRect.origin.y + boundingMapRect.size.height),
            MKMapPointMake(boundingMapRect.origin.x, boundingMapRect.origin.y + boundingMapRect.size.height)
        };
        MKPolygonRenderer *renderer = [[MKPolygonRenderer alloc] initWithPolygon:[MKPolygon polygonWithPoints:polygonPoints count:4]];
        renderer.fillColor = [UIColor blackColor];
        return renderer;
    }
    return nil;
}


// This is not smooth enough for presentation yet

/*
- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    self.lastValidMapRegion = mapView.region;
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if (!self.isAdjustingToValidMapRegion) {
    
        MKCoordinateRegion restrictedRegion = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(49.410029, 8.677434), 5000, 5000);
        BOOL adjustRegion = NO;
        if ((mapView.region.span.latitudeDelta > restrictedRegion.span.latitudeDelta * 2) || (mapView.region.span.longitudeDelta > restrictedRegion.span.longitudeDelta * 2) ) {
            adjustRegion = YES;
        }
        if (!MKMapRectIntersectsRect(self.mapView.visibleMapRect, MKMapRectForCoordinateRegion(restrictedRegion))) {
            adjustRegion = YES;
        }
        if (adjustRegion) {
            self.isAdjustingToValidMapRegion = YES;
            [mapView setRegion:self.lastValidMapRegion animated:YES];
            self.isAdjustingToValidMapRegion = NO;
        }
    }
    
    /*if ((mapView.region.span.latitudeDelta > 0.0596 ) || (mapView.region.span.longitudeDelta > 0.071736) ) {
        
        CLLocationCoordinate2D centerCoord = CLLocationCoordinate2DMake(49.4085, 8.68685);

        MKCoordinateSpan spanOfNZ = MKCoordinateSpanMake(0.0596, 0.071736);
        
        MKCoordinateRegion NZRegion = MKCoordinateRegionMake(centerCoord, spanOfNZ);
        
        [mapView setRegion: NZRegion animated: YES];
        
    }
        
    if (mapView.region.center.latitude > 49.44 ) {
        
        CLLocationCoordinate2D centerCoord = CLLocationCoordinate2DMake(49.44, mapView.region.center.longitude);
        
        MKCoordinateSpan spanOfNZ = mapView.region.span;
        
        MKCoordinateRegion NZRegion = MKCoordinateRegionMake(centerCoord, spanOfNZ);
        
        [mapView setRegion: NZRegion animated: YES];
        
    }
    
    if (mapView.region.center.latitude < 49.4085 ) {
        
        CLLocationCoordinate2D centerCoord = CLLocationCoordinate2DMake(49.4085, mapView.region.center.longitude);
        
        MKCoordinateSpan spanOfNZ = mapView.region.span;
        
        MKCoordinateRegion NZRegion = MKCoordinateRegionMake(centerCoord, spanOfNZ);
        
        [mapView setRegion: NZRegion animated: YES];
        
    }
    
    if (mapView.region.center.longitude > 8.735 ) {
        
        CLLocationCoordinate2D centerCoord = CLLocationCoordinate2DMake(mapView.region.center.latitude, 8.735);
        
        MKCoordinateSpan spanOfNZ = mapView.region.span;
        
        MKCoordinateRegion NZRegion = MKCoordinateRegionMake(centerCoord, spanOfNZ);
        
        [mapView setRegion: NZRegion animated: YES];
    }
    
    if (mapView.region.center.longitude < 8.6387 ) {
        
        CLLocationCoordinate2D centerCoord = CLLocationCoordinate2DMake(mapView.region.center.latitude, 8.6387);
        
        MKCoordinateSpan spanOfNZ = mapView.region.span;
        
        MKCoordinateRegion NZRegion = MKCoordinateRegionMake(centerCoord, spanOfNZ);
        
        [mapView setRegion: NZRegion animated: YES];
    }
    
    self.isAdjustingToValidMapRegion = NO;

}*/


#pragma mark - Gesture Recognizer Delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    // TODO: there should be a better way to make the callout button work...
    if ([touch.view isKindOfClass:[UIControl class]]) {
        return NO;
    }
    return YES;
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

