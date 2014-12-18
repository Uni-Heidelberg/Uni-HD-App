//
//  UHDNewsCategoryViewController.m
//  uni-hd
//
//  Created by Andreas Schachner on 21.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDNewsSourcesViewController.h"
#import "VIFetchedResultsControllerDataSource.h"

// Model
#import "UHDNewsSource.h"

// Table View Cells
#import "UHDNewsSourceCell.h"


@interface UHDNewsSourcesViewController () <UHDNewsSourceCellDelegate>

@property (strong, nonatomic) VIFetchedResultsControllerDataSource *fetchedResultsControllerDataSource;

@end


@implementation UHDNewsSourcesViewController

- (void)setCategory:(UHDNewsCategory *)category
{
	_category = category;
	self.managedObjectContext = category.managedObjectContext;
}

#pragma mark - User Interaction

- (IBAction)refreshControlValueChanged:(UIRefreshControl *)sender
{
    [[[UHDRemoteDatasourceManager defaultManager] remoteDatasourceForKey:UHDRemoteDatasourceKeyNews] refreshWithCompletion:^(BOOL success, NSError *error) {
        [sender endRefreshing];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"showCategory"]) {
		[segue.destinationViewController setCategory:[self.fetchedResultsControllerDataSource selectedItem]];
	}
}

- (void)sourceCellSubscribedValueChanged:(UHDNewsSourceCell *)cell
{
    UHDNewsSource *source = [self.fetchedResultsControllerDataSource.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForCell:cell]];
    source.subscribed = cell.subscribedSwitch.on;
    [source.managedObjectContext saveToPersistentStore:nil];
}

#pragma mark - Data Source

- (VIFetchedResultsControllerDataSource *)fetchedResultsControllerDataSource
{
    if (!_fetchedResultsControllerDataSource)
    {
        if (!self.managedObjectContext) {
            [self.logger log:@"Unable to create fetched results controller without a managed object context" forLevel:VILogLevelWarning];
            return nil;
        }

        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[UHDNewsCategory entityName]];
        fetchRequest.includesSubentities = YES;
		NSString *sectionNameKeyPath = nil;
		if (!self.category) {
			fetchRequest.predicate = [NSPredicate predicateWithFormat:@"parent.parent = nil && parent != nil"];
			fetchRequest.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"parent.title" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES] ];
			sectionNameKeyPath = @"parent.title";
		} else {
			fetchRequest.predicate = [NSPredicate predicateWithFormat:@"parent = %@", self.category ];
			fetchRequest.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES] ];
		}
        
        NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:sectionNameKeyPath cacheName:nil];
        
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
	return [self.fetchedResultsControllerDataSource numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.fetchedResultsControllerDataSource tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UHDNewsCategory *item = [self.fetchedResultsControllerDataSource.fetchedResultsController objectAtIndexPath:indexPath];
	
	UITableViewCell *cell = nil;
	
	if ([[item entityName] isEqualToString:[UHDNewsSource entityName]]) {
		cell = [tableView dequeueReusableCellWithIdentifier:@"sourceCell" forIndexPath:indexPath];
        ((UHDNewsSourceCell *)cell).delegate = self;
		[(UHDNewsSourceCell *)cell configureForSource:(UHDNewsSource *)item];
	} else {
		cell = [tableView dequeueReusableCellWithIdentifier:@"categoryCell" forIndexPath:indexPath];
		cell.textLabel.text = item.title;
        int subscribedCount = [item subscribedCount];
        if (subscribedCount > 0) {
            cell.detailTextLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%i abonniert", nil), subscribedCount];
        } else {
            cell.detailTextLabel.text = nil;
        }
	}
	
	return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return [self.fetchedResultsControllerDataSource tableView:tableView titleForHeaderInSection:section];
}


@end
