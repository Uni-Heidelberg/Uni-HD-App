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

// View Controllers
#import "UHDMapsSearchTableViewController.h"
#import "UHDBuildingDetailViewController.h"


@interface UHDMapsViewController () <MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) MKAnnotationView *mapAnnotationView;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (strong, nonatomic) IBOutlet UISegmentedControl *mapTypeControl;
- (IBAction)mapTypeControlValueChanged:(id)sender;

@end


@implementation UHDMapsViewController

- (void)viewWillAppear:(BOOL)inAnimated {
    [super viewWillAppear:inAnimated];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Das self.fetchedResultsController Attribut wird verwendet (unten ist der Getter, der das Objekt erstellt wenn es noch nicht existiert)
    // In den anderen View Controllern wird häufig VIFetchedResultsControllerDataSource verwendet. Diese Klasse implementiert nützliche Zusatzfunktionalität um einen NSFetchedResultsController, hauptsächlich um die Objekte einfach in einer Table View darstellen zu können (Animationen bei Änderungen usw.). Hier brauchen wir das erstmal nicht, da wir keine Table View haben.
    // In der Dokumentation zu NSFetchedResultsController sind die Methoden beschrieben, die zur Verfügung stehen (cmd+shift+0).
    // Wenn sich die zugrundeliegende Datenbank ändert kann man darauf reagieren, indem die Delegate Methoden des NSFetchedResultsControllerDelegate implementiert werden (s. Doku).
    // Um die Abfrage umzukonfigurieren (z.B. andere Entities, andere Sortierung usw.) kann die Fetch Request angepasst werden (self.fetchedResultsController.fetchRequest). Danach muss wieder ein performFetch (wie unten) ausgeführt werden.
    
    NSArray *allBuildings = self.fetchedResultsController.fetchedObjects;
    
    [self.mapView addAnnotations:allBuildings];
    [self.mapView showAnnotations:allBuildings animated:YES];
    
    MKMapSnapshotOptions *options = [[MKMapSnapshotOptions alloc] init];
    options.region = self.mapView.region;
    options.size = self.mapView.frame.size;
    options.scale = [[UIScreen mainScreen] scale];
    
    NSURL *fileURL = [NSURL fileURLWithPath:@"inf_10_2013"];
    
    MKMapSnapshotter *snapshotter = [[MKMapSnapshotter alloc] initWithOptions:options];
    [snapshotter startWithCompletionHandler:^(MKMapSnapshot *snapshot, NSError *error) {
        if (error) {
            NSLog(@"[Error] %@", error);
            return;
        }
        
        UIImage *image = snapshot.image;
        NSData *data = UIImagePNGRepresentation(image);
        [data writeToURL:fileURL atomically:YES];
    }];
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showMapsSearch"]) {
        // Hier muss der MOC (die "Verbindung" zur Datenbank) an den Maps Search VC weitergegeben werden
        UHDMapsSearchTableViewController *mapsSearchVC = segue.destinationViewController;
        mapsSearchVC.managedObjectContext = self.managedObjectContext;
    }
}


- (NSFetchedResultsController *)fetchedResultsController {
    if (!_fetchedResultsController) {

        // Ein NSFetchedResultsController Objekt holt Daten aus der Core Data Datenbank und reagiert auf Änderungen.
        
        // Es benötigt eine Fetch Request, das die Entity beschreibt, deren Datenbankeinträge abgefragt werden sollen und einige Eigenschaften wie die Sortierung.
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[UHDBuilding entityName]];
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
        // Mit einem Predikat kann die Abfrage gefiltert werden (Kommentar entfernen zum ausprobieren):
        // fetchRequest.predicate = [NSPredicate predicateWithFormat:@"title LIKE %@", @"Marstall"];
        // Siehe z.B. Doku für Infos zur Predikatsyntax
        // Dann kann der NSFetchedResultsController mit der Fetch Request erstellt werden. Das NSManagedObjectContext Objekt, das die "Verbindung" zur Datenbank darstellt, wird dieser Klasse vom App Delegate übergeben.
        NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        
        // Die Datenbankabfrage kann nun ausgeführt werden.
        [fetchedResultsController performFetch:NULL];
        
        self.fetchedResultsController = fetchedResultsController;
    }
    return _fetchedResultsController;
}

//Show informations in annotations
/*
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    UHDBuilding *item;
    NSIndexPath *indexPath;
    item = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    
    //if ([allBuildings containsObject:item]) {
        
        annotation = item;
        
        if ([annotation isKindOfClass:[MKUserLocation class]]){
        
        return nil;
            
        }
        
        // Customize Pin View
        if (building.image) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)]; // TODO: dynamic size?
            imageView.image = building.image;
            pinView.leftCalloutAccessoryView = imageView;
        } else {
            pinView.leftCalloutAccessoryView = nil;
        }
        
        return pinView;
    }
    //}
    return nil;
    
}
*/
/*
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id)annotation
{
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"MyPin"];
    if (!annotationView) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MyPin"];
        annotationView.canShowCallout = YES;
        annotationView.animatesDrop = YES;
        annotationView.pinColor = MKPinAnnotationColorPurple;
    }
    
    annotationView.annotation = annotation;
    
    return annotationView;
}
*/

//Configure Map Type

- (IBAction)changeMapType:(id)sender {
    
    //Segment 1 hat Nummer 0 usw.
    if (_mapType.selectedSegmentIndex == 0) {
        [self.mapView setMapType:MKMapTypeStandard];
    }
    else if (_mapType.selectedSegmentIndex == 1){
        [self.mapView setMapType:MKMapTypeHybrid];
    }
    else if (_mapType.selectedSegmentIndex == 2){
        [self.mapView setMapType:MKMapTypeSatellite];
    }
    
}

#pragma mark - MKMapViewDelegate

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView
            rendererForOverlay:(id <MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKTileOverlay class]]) {
        return [[MKTileOverlayRenderer alloc] initWithTileOverlay:overlay];
    }
    
    return nil;
}


@end
