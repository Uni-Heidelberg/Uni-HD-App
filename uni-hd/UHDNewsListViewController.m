//
//  UHDNewsListViewController.m
//  uni-hd
//
//  Created by Nils Fischer on 20.06.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDNewsListViewController.h"

#import "VIFetchedResultsControllerDataSource.h"
#import "UHDRemoteDatasourceManager.h"

// View Controllers
#import "UHDNewsDetailViewController.h"

// Table View Cells
#import "UHDNewsItemCell.h"
#import "UHDEventItemCell.h"
#import "UHDTalkItemCell.h"


@interface UHDNewsListViewController ()

@property (strong, nonatomic, readonly) VIFetchedResultsControllerDataSource *fetchedResultsControllerDataSource;
@property (strong, nonatomic) VIFetchedResultsControllerDataSource *fetchedResultsControllerDataSourceNews;
@property (strong, nonatomic) VIFetchedResultsControllerDataSource *fetchedResultsControllerDataSourceEvents;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)refreshControlValueChanged:(id)sender;

@end


@implementation UHDNewsListViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 200;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.tableView.dataSource = self;
	self.tableView.delegate = self;
}

- (void)setSources:(NSArray *)sources
{
    _sources = sources;
    self.managedObjectContext = [(NSManagedObject *)[sources lastObject] managedObjectContext];
    if (!self.title&&self.sources.count > 0) {
        self.title = [sources[0] title];
    }
    self.fetchedResultsControllerDataSourceNews.fetchedResultsController.fetchRequest.predicate = [NSPredicate predicateWithFormat:@"source IN %@", self.sources];
    self.fetchedResultsControllerDataSourceEvents.fetchedResultsController.fetchRequest.predicate = [NSPredicate predicateWithFormat:@"source IN %@", self.sources];
    [self.fetchedResultsControllerDataSourceNews reloadData];
    [self.fetchedResultsControllerDataSourceEvents reloadData];
}

- (void)setDisplayMode:(UHDNewsListDisplayMode)displayMode
{
	_displayMode = displayMode;
    [self.tableView reloadData];
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
    if ([segue.identifier isEqualToString:@"showNewsDetail"]) {
        
        UHDNewsDetailViewController *newsDetailVC = segue.destinationViewController;
        
        // Mark item as read
        UHDNewsItem *item = self.fetchedResultsControllerDataSource.selectedItem;
        item.read = YES;
        [item.managedObjectContext saveToPersistentStore:NULL];
        
        newsDetailVC.newsItem = item;
    }
	else if ([segue.identifier isEqualToString:@"showEventDetail"]) {
	
		UHDNewsDetailViewController *newsDetailVC = segue.destinationViewController;
        
        UHDEventItem *item = self.fetchedResultsControllerDataSource.selectedItem;
        item.read = YES;
        [item.managedObjectContext saveToPersistentStore:NULL];
        
        newsDetailVC.newsItem = item;
	
	}
	else if ([segue.identifier isEqualToString:@"showTalkDetail"]) {
		UHDNewsDetailViewController *newsDetailVC = segue.destinationViewController;
        
        UHDTalkItem *item = self.fetchedResultsControllerDataSource.selectedItem;
        item.read = YES;
        [item.managedObjectContext saveToPersistentStore:NULL];
        
        newsDetailVC.newsItem = item;
	}
}


#pragma mark - Data Source

- (VIFetchedResultsControllerDataSource *)fetchedResultsControllerDataSource
{
    if (self.displayMode == UHDNewsListDisplayModeNews) {
		return self.fetchedResultsControllerDataSourceNews;
	}
	else {
		return self.fetchedResultsControllerDataSourceEvents;
	}
}

- (VIFetchedResultsControllerDataSource *)fetchedResultsControllerDataSourceNews {
    if (!_fetchedResultsControllerDataSourceNews)
    {
        if (!self.managedObjectContext) {
            [self.logger log:@"Unable to create fetched results controller without a managed object context" forLevel:VILogLevelWarning];
            return nil;
        }
        
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[UHDNewsItem entityName]];

        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
        
        NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        
		VIFetchedResultsControllerDataSource *fetchedResultsControllerDataSource = [[VIFetchedResultsControllerDataSource alloc] init];
		fetchedResultsControllerDataSource.tableView = self.tableView;
		fetchedResultsControllerDataSource.fetchedResultsController = fetchedResultsController;
		self.fetchedResultsControllerDataSourceNews = fetchedResultsControllerDataSource;
		
    }
	return _fetchedResultsControllerDataSourceNews;
}

- (VIFetchedResultsControllerDataSource *)fetchedResultsControllerDataSourceEvents
{
    if (!_fetchedResultsControllerDataSourceEvents)
    {
        if (!self.managedObjectContext) {
            [self.logger log:@"Unable to create fetched results controller without a managed object context" forLevel:VILogLevelWarning];
            return nil;
        }

        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[UHDEventItem entityName]];
		[fetchRequest setIncludesSubentities:YES];

        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
        
        NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        
        /*VITableViewCellConfigureBlock configureCellBlock = ^(UITableViewCell *cell, id item) {
            [(UHDEventItemCell *)cell configureForItem:item];
        };
		
		// TODO: discriminate between UHDEventItemCell and UHDTalkItemCell
		// override table view delegate methods like in UHDNewsSourcesViewController
        
        self.fetchedResultsControllerDataSourceEvents = [[VIFetchedResultsControllerDataSource alloc] initWithFetchedResultsController:fetchedResultsController tableView:self.tableView cellIdentifier:@"eventCell" configureCellBlock:configureCellBlock];*/
		
		VIFetchedResultsControllerDataSource *fetchedResultsControllerDataSource = [[VIFetchedResultsControllerDataSource alloc] init];
		fetchedResultsControllerDataSource.tableView = self.tableView;
		fetchedResultsControllerDataSource.fetchedResultsController = fetchedResultsController;
		self.fetchedResultsControllerDataSourceEvents = fetchedResultsControllerDataSource;
		
    }
    return _fetchedResultsControllerDataSourceEvents;
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
	UITableViewCell *cell = nil;

	if (self.displayMode == UHDNewsListDisplayModeNews) {

        static NSString *newsCellIdentifier = @"newsCell";

        UHDNewsItem *item = [self.fetchedResultsControllerDataSource.fetchedResultsController objectAtIndexPath:indexPath];
	
        cell = [tableView dequeueReusableCellWithIdentifier:newsCellIdentifier forIndexPath:indexPath];
		[(UHDNewsItemCell *)cell configureForItem:item];
	
	}
	else {
	
		UHDEventItem *item = [self.fetchedResultsControllerDataSource.fetchedResultsController objectAtIndexPath:indexPath];
		
		if ([[item entityName] isEqualToString:[UHDEventItem entityName]]) {
			cell = [tableView dequeueReusableCellWithIdentifier:@"eventCell" forIndexPath:indexPath];
			[(UHDEventItemCell *)cell configureForItem:item];
		}
		else {
			cell = [tableView dequeueReusableCellWithIdentifier:@"talkCell" forIndexPath:indexPath];
			[(UHDTalkItemCell *)cell configureForItem:(UHDTalkItem *)item];
		}
		[cell setNeedsLayout];
		[cell layoutIfNeeded];
	}
	return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return [self.fetchedResultsControllerDataSource tableView:tableView titleForHeaderInSection:section];
}



@end
