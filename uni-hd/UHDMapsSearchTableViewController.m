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
#import "UHDBuildingDetailViewController.h"

//Model
#import "UHDBuilding.h"
#import "UHDRemoteManagedLocation.h"
#import "UHDLocationCategory.h"

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
    
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    self.navigationItem.titleView = searchBar;
}

- (void)configureView
{
    self.title = @"Suche";

    self.tableView.dataSource = self;
    self.tableView.delegate = self;

}

#pragma mark - Data Source

- (VIFetchedResultsControllerDataSource *)fetchedResultsControllerDataSource
{
    if (!_fetchedResultsControllerDataSource) {
        
    if (!self.managedObjectContext) {
       [self.logger log:@"Unable to create fetched results controller without a managed object context" forLevel:VILogLevelWarning];
        return nil;
   }
        
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[UHDBuilding entityName]];
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"category.title" ascending:YES],[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
        NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"category.title" cacheName:nil];
        [fetchedResultsController performFetch:NULL];

		VIFetchedResultsControllerDataSource *fetchedResultsControllerDataSource = [[VIFetchedResultsControllerDataSource alloc] init];
		fetchedResultsControllerDataSource.tableView = self.tableView;
		fetchedResultsControllerDataSource.fetchedResultsController = fetchedResultsController;
        self.fetchedResultsControllerDataSource = fetchedResultsControllerDataSource;

    }
    
	return _fetchedResultsControllerDataSource;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showBuildingDetail"])
    {
        UHDBuildingDetailViewController *destViewController = segue.destinationViewController;

            NSIndexPath *indexPath= nil;
            UHDBuilding *item = nil;
            indexPath = [self.tableView indexPathForSelectedRow];
            item = [self.filteredObjects objectAtIndex:indexPath.row];
            destViewController.building = item;
    }
}

#pragma mark - Table View Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
 
        return 1;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

        return self.filteredObjects.count;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell;
    UHDBuilding *item;
    
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"mapsSearchCell"];
        item = [self.filteredObjects objectAtIndex:indexPath.row];
    
    [(UHDMapsSearchCell *)cell configureForItem:item];
	return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
        return nil;

}


#pragma mark - Search Results Filtering

-(BOOL)searchDisplayController:(UISearchDisplayController *)Controller shouldReloadTableForSearchString:(NSString *)searchString
{    
    self.filteredObjects = [self.fetchedResultsControllerDataSource.fetchedResultsController.fetchedObjects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"title CONTAINS[cd] %@", searchString]];
    return YES;
}


@end
