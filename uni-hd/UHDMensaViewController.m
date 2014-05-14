//
//  UHDMensaViewController.m
//  uni-hd
//
//  Created by Felix on 07.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDMensaViewController.h"
#import "UHDModuleStore.h"
#import "UHDLocation.h"
#import "UHDMensa.h"
#import "VIFetchedResultsControllerDataSource.h"

@interface UHDMensaViewController ()
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) VIFetchedResultsControllerDataSource *fetchedResultsControllerDataSource;

@end

@implementation UHDMensaViewController

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    /*
    // Generate Sample Data
    UHDLocation *location = [UHDLocation insertNewObjectIntoContext:context];
    location.latitude = 49.416283;
    location.longitude = 8.672503;
    
    UHDMensa *mensa = [UHDMensa insertNewObjectIntoContext:context];
    mensa.location = location;
    mensa.title = @"Marstall";
    
    NSError *error = nil;
    if (![context save:&error]) {
        [self.logger log:@"Context Save" error:error];
    }*/

    /*
    // Fetch Stuff
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[UHDMensa entityName]];
    NSArray *mensen = [context executeFetchRequest:request error:NULL];
    
    for (UHDMensa *mensa in mensen) {

        [self.logger log:mensa.title forLevel:VILogLevelDebug];
        
    }
    */
    
    // redirect datasource
    self.tableView.dataSource = self.fetchedResultsControllerDataSource;
    
}

- (VIFetchedResultsControllerDataSource *)fetchedResultsControllerDataSource {
    if (!_fetchedResultsControllerDataSource) {
        
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[UHDMensa entityName]];
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];

        NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[UHDModuleStore defaultStore].managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        
        
        VITableViewCellConfigureBlock configureCellBlock = ^(UITableViewCell *cell, UHDMensa *item) {
            cell.textLabel.text = item.title;
        };
        
        self.fetchedResultsControllerDataSource = [[VIFetchedResultsControllerDataSource alloc] initWithFetchedResultsController:fetchedResultsController tableView:self.tableView cellIdentifier:@"mensaCell" configureCellBlock:configureCellBlock];
        
    }
    return _fetchedResultsControllerDataSource;
}




@end
