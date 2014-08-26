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


@interface UHDMapsViewController ()

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

//to do: Change Map Style
//- (void)changeDisplayMode;

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
    //[self.theView setAnnotation:allBuildings];
    
    
    
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






@end
