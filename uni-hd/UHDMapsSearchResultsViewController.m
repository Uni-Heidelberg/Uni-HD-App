//
//  UHDMapsSearchTableViewController.m
//  uni-hd
//
//  Created by Andreas Schachner on 13.08.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDMapsSearchResultsViewController.h"
#import "VIFetchedResultsControllerDataSource.h"
#import "UHDRemoteDatasourceManager.h"

// Model
#import "UHDBuilding.h"
#import "UHDRemoteManagedLocation.h"
#import "UHDLocationCategory.h"
#import "UHDCampusRegion.h"

// Table View Cells
#import "UHDBuildingCell.h"


@interface UHDMapsSearchResultsViewController ()

@property (strong, nonatomic) VIFetchedResultsControllerDataSource *fetchedResultsControllerDataSource;

@end


@implementation UHDMapsSearchResultsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.dataSource = self.fetchedResultsControllerDataSource;
    self.tableView.delegate = self;
    
    [self configureView];
}

- (void)configureView
{
    
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
        fetchRequest.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"category.title" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES] ];
        
        NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"category.title" cacheName:nil];
        
        VIFetchedResultsControllerDataSource *fetchedResultsControllerDataSource = [[VIFetchedResultsControllerDataSource alloc] initWithFetchedResultsController:fetchedResultsController tableView:self.tableView cellIdentifier:@"buildingCell" configureCellBlock:^(UITableViewCell *cell, id item) {
            [(UHDBuildingCell *)cell configureForBuilding:(UHDBuilding *)item];
        }];
        _fetchedResultsControllerDataSource = fetchedResultsControllerDataSource;
    }
    
    return _fetchedResultsControllerDataSource;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showBuildingDetailFromSearchResults"]) {
        //((UHDBuildingDetailViewController *)segue.destinationViewController).building = [self.fetchedResultsControllerDataSource.fetchedResultsController objectAtIndexPath:self.tableView.indexPathForSelectedRow];
        [(UHDBuildingDetailViewController *)segue.destinationViewController setBuilding:(UHDBuilding *)[self.fetchedResultsControllerDataSource.fetchedResultsController objectAtIndexPath:self.tableView.indexPathForSelectedRow]];
    }
}

#pragma mark - Search Results Filtering



-(void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchText = [searchController.searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [self.logger log:@"Updating search results for search text" object:searchText forLevel:VILogLevelVerbose];
    NSArray *searchTerms = [searchText componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *predicateFormat = @"(title CONTAINS[cd] %@) OR (buildingNumber CONTAINS[cd] %@) OR (campusRegion.title CONTAINS[cd] %@) OR (campusRegion.identifier CONTAINS[cd] %@)";
    NSPredicate *predicate;
    if ([searchTerms count] == 1) {
        NSString *term = [searchTerms firstObject];
        predicate = [NSPredicate predicateWithFormat:predicateFormat, term, term, term, term];
    } else {
        NSMutableArray *subPredicates = [NSMutableArray array];
        for (NSString *term in searchTerms) {
            NSPredicate *p = [NSPredicate predicateWithFormat:predicateFormat, term, term, term, term];
            [subPredicates addObject:p];
        }
        predicate = [NSCompoundPredicate andPredicateWithSubpredicates:subPredicates];
    }
    
    self.fetchedResultsControllerDataSource.fetchedResultsController.fetchRequest.predicate = predicate;

    [self.fetchedResultsControllerDataSource reloadData];
}


#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UHDBuilding *item = [self.fetchedResultsControllerDataSource.fetchedResultsController objectAtIndexPath:indexPath];
    [self.delegate searchResultsViewController:self didSelectBuilding:item];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    UHDBuilding *item = [self.fetchedResultsControllerDataSource.fetchedResultsController objectAtIndexPath:indexPath];
    UHDBuildingDetailViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"buildingDetail"];
    detailVC.building = item;
    UIViewController *pv = self.parentViewController;
    [((UIViewController *)((UISearchController *)self.parentViewController).delegate).navigationController pushViewController:detailVC animated:YES]; // TODO: this is super dirty, use segue instead
}

@end
