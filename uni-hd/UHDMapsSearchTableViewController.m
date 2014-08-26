//
//  UHDMapsSearchTableViewController.m
//  uni-hd
//
//  Created by Andreas Schachner on 13.08.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDMapsSearchTableViewController.h"
#import "VIFetchedResultsControllerDataSource.h"
#import "UHDRemoteDatasourceManager.h"

//Model
#import "UHDBuilding.h"
#import "UHDRemoteManagedLocation.h"
//#import "UHDBuildingsCategory.h"

#import "UHDMapsSearchCell+ConfigureForItem.h"
#import "UHDMapsSearchCell.h"


@interface UHDMapsSearchTableViewController () <UISearchDisplayDelegate>

@property (strong, nonatomic) VIFetchedResultsControllerDataSource *fetchedResultsControllerDataSource;
@property (strong, nonatomic) NSArray *filteredObjects;

@property (strong, nonatomic) NSArray *searchResult;

@end

@implementation UHDMapsSearchTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
    
    self.tableView.dataSource = self.fetchedResultsControllerDataSource.fetchedResultsController.fetchedObjects;
    self.tableView.delegate = self;
    
    
    
    
}

- (void)configureView
{
    self.title = @"Suche";

    //self.tableView.dataSource = self;
    //self.tableView.delegate = self;

}

#pragma mark - Data Source

-(void)setBuildingsList:(NSArray *)buildingsList{
    
    buildingsList = self.fetchedResultsControllerDataSource.fetchedResultsController.fetchedObjects;
    
    //self.fetchedResultsControllerDataSource.fetchedResultsController.fetchRequest.predicate = [NSPredicate predicateWithFormat:@"building IN %@", buildingsList];
    //[self.fetchedResultsControllerDataSource reloadData];
    
    [self configureView];
    
}

- (VIFetchedResultsControllerDataSource *)fetchedResultsControllerDataSource
{
    if (!_fetchedResultsControllerDataSource) {
        
    if (!self.managedObjectContext) {
       [self.logger log:@"Unable to create fetched results controller without a managed object context" forLevel:VILogLevelWarning];
        return nil;
   }
        
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[UHDBuilding entityName]];
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
        NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        [fetchedResultsController performFetch:NULL];
        
        
        //NSFetchedResultController mit Category
    
        //NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[UHDBuilding entityName]];
    
        //fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"category.remoteObjectId" ascending:YES],[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
        
        //NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"category.title" cacheName:nil];
        
        //[fetchedResultsController performFetch:NULL];
        
        
		VIFetchedResultsControllerDataSource *fetchedResultsControllerDataSource = [[VIFetchedResultsControllerDataSource alloc] init];
		fetchedResultsControllerDataSource.tableView = self.tableView;
		fetchedResultsControllerDataSource.fetchedResultsController = fetchedResultsController;
        self.fetchedResultsControllerDataSource = fetchedResultsControllerDataSource;

    }
    
	return _fetchedResultsControllerDataSource;
}

#pragma mark - Table View Datasource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView==self.searchDisplayController.searchResultsTableView) {
        return 1;
    }
    return [self.fetchedResultsControllerDataSource numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==self.searchDisplayController.searchResultsTableView) {
        return self.filteredObjects.count;
    }
    return [self.fetchedResultsControllerDataSource tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell;
    UHDBuilding *item;
    
    if (tableView==self.searchDisplayController.searchResultsTableView) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"mapsSearchCell"];
        item = [self.filteredObjects objectAtIndex:indexPath.row];
    } else {
		cell = [self.tableView dequeueReusableCellWithIdentifier:@"mapsSearchCell" forIndexPath:indexPath];
		item = [self.fetchedResultsControllerDataSource.fetchedResultsController objectAtIndexPath:indexPath];
    }
    
    [(UHDMapsSearchCell *)cell configureForItem:item];
	return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView==self.searchDisplayController.searchResultsTableView) {
        return nil;
    }
    return [self.fetchedResultsControllerDataSource tableView:tableView titleForHeaderInSection:section];
}


#pragma mark - Search Results Filtering


@end
