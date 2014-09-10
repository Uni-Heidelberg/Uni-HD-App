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
#import "UHDCampusRegionRenderer.h"
#import "UHDBuildingAnnotationView.h"


@interface UHDMapsViewController () <MKMapViewDelegate, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSFetchedResultsController *campusRegionsFetchedResultsController;

@property (strong, nonatomic) IBOutlet UISegmentedControl *mapTypeControl;
- (IBAction)mapTypeControlValueChanged:(id)sender;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *trackingButton;
@property (strong, nonatomic)IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) CLLocationManager *locationManager;


@end


@implementation UHDMapsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Das self.fetchedResultsController Attribut wird verwendet (unten ist der Getter, der das Objekt erstellt wenn es noch nicht existiert)
    // In den anderen View Controllern wird häufig VIFetchedResultsControllerDataSource verwendet. Diese Klasse implementiert nützliche Zusatzfunktionalität um einen NSFetchedResultsController, hauptsächlich um die Objekte einfach in einer Table View darstellen zu können (Animationen bei Änderungen usw.). Hier brauchen wir das erstmal nicht, da wir keine Table View haben.
    // In der Dokumentation zu NSFetchedResultsController sind die Methoden beschrieben, die zur Verfügung stehen (cmd+shift+0).
    // Wenn sich die zugrundeliegende Datenbank ändert kann man darauf reagieren, indem die Delegate Methoden des NSFetchedResultsControllerDelegate implementiert werden (s. Doku).
    // Um die Abfrage umzukonfigurieren (z.B. andere Entities, andere Sortierung usw.) kann die Fetch Request angepasst werden (self.fetchedResultsController.fetchRequest). Danach muss wieder ein performFetch (wie unten) ausgeführt werden.
    
    // Add overlays
    NSArray *allCampusRegions = self.campusRegionsFetchedResultsController.fetchedObjects;
    [self.mapView addOverlays:allCampusRegions];
    [self.mapView addAnnotations:allCampusRegions];

    // Add all annotations
    NSArray *allBuildings = self.fetchedResultsController.fetchedObjects;
    [self.mapView addAnnotations:allBuildings];
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

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    CLLocationCoordinate2D currentCoordinates;
    currentCoordinates.latitude = newLocation.coordinate.latitude;
    currentCoordinates.longitude = newLocation.coordinate.longitude;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMake(currentCoordinates, _mapView.region.span);
    [_mapView setRegion:viewRegion animated:YES];
    [self.locationManager stopUpdatingLocation];
    
}

/*
-(void)setTrackingButton:(UIBarButtonItem *)trackingButton{
    self.trackingButton = [[MKUserTrackingBarButtonItem alloc] initWithMapView:self.mapView];
    NSMutableArray *items = [[NSMutableArray alloc] initWithArray:self.toolbar.items];
    [items addObject:self.trackingButton];
    [self.toolbar setItems:items];
    
}
 */
-(UIBarButtonItem *)trackingButton{
    
    self.trackingButton = [[MKUserTrackingBarButtonItem alloc] initWithMapView:self.mapView];
    NSMutableArray *items = [[NSMutableArray alloc] initWithArray:self.toolbar.items];
    [items addObject:self.trackingButton];
    [self.toolbar setItems:items];
    return self.trackingButton;
}

- (IBAction)moveToCurrentLocation:(id)sender {

    [self.locationManager startUpdatingLocation];
}

#pragma mark - User Interaction

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showMapsSearch"]) {
        // Hier muss der MOC (die "Verbindung" zur Datenbank) an den Maps Search VC weitergegeben werden
        UHDMapsSearchTableViewController *mapsSearchVC = segue.destinationViewController;
        mapsSearchVC.managedObjectContext = self.managedObjectContext;
    } else if ([segue.identifier isEqualToString:@"showBuildingDetail"]) {
        [(UHDBuildingDetailViewController *)segue.destinationViewController setBuilding:(UHDBuilding *)[(MKAnnotationView *)sender annotation]];
    }
}

- (IBAction)mapTypeControlValueChanged:(id)sender {
    
    switch (self.mapTypeControl.selectedSegmentIndex) {
        case 0:
            self.mapView.mapType = MKMapTypeStandard;
            break;
        case 1:
            self.mapView.mapType = MKMapTypeHybrid;
            break;
        case 2:
            self.mapView.mapType = MKMapTypeSatellite;
            break;
        default:
            break;
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"showBuildingDetail" sender:view];
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
            buildingAnnotationView = [[UHDBuildingAnnotationView alloc] initWithAnnotation:building reuseIdentifier:@"UHDBuildingPin"];
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
        return [[UHDCampusRegionRenderer alloc] initWithCampusRegion:(UHDCampusRegion *)overlay];
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
