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

#import "UHDNewsDetailViewController.h"

#import "UHDNewsItem.h"
#import "UHDEventItem.h"
#import "UHDTalkItem.h"
#import "UHDNewsSource.h"

// Table View Cells
#import "UHDNewsItemCell.h"
#import "UHDEventItemCell.h"
//#import "UHDTalkItem."
#import "UHDNewsItemCell+ConfigureForItem.h"

#import "UHDEventItemCell+ConfigureForItem.h"



@interface UHDNewsListViewController ()

@property (strong, nonatomic, readonly) VIFetchedResultsControllerDataSource *fetchedResultsControllerDataSource;
@property (strong, nonatomic) VIFetchedResultsControllerDataSource *fetchedResultsControllerDataSourceNews;
@property (strong, nonatomic) VIFetchedResultsControllerDataSource *fetchedResultsControllerDataSourceEvents;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)refreshControlValueChanged:(id)sender;

- (void)changeDisplayMode;

@end


@implementation UHDNewsListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // redirect data source
    self.tableView.dataSource = self.fetchedResultsControllerDataSource;
}

- (void)setSources:(NSArray *)sources
{
    _sources = sources;
    self.managedObjectContext = [(NSManagedObject *)[sources lastObject] managedObjectContext];
    if (!self.title) {
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
	[self changeDisplayMode];
}

- (void) changeDisplayMode
{
	/*if (self.displayMode == UHDNewsListDisplayModeNews) {
    	[self.logger log:@"news mode" error:Nil];
	}
	else {
		[self.logger log:@"events mode" error:Nil];
	}*/
	self.tableView.dataSource = self.fetchedResultsControllerDataSource;
	[self.tableView reloadData];
};


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
        
        VITableViewCellConfigureBlock configureCellBlock = ^(UITableViewCell *cell, id item) {
            [(UHDNewsItemCell *)cell configureForItem:item];
        };
        
        self.fetchedResultsControllerDataSourceNews = [[VIFetchedResultsControllerDataSource alloc] initWithFetchedResultsController:fetchedResultsController tableView:self.tableView cellIdentifier:@"newsCell" configureCellBlock:configureCellBlock];
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
        
        VITableViewCellConfigureBlock configureCellBlock = ^(UITableViewCell *cell, id item) {
            [(UHDEventItemCell *)cell configureForItem:item];
        };
		
		// TODO: discriminate between UHDEventItemCell and UHDTalkItemCell
		// override table view delegate methods like in UHDNewsSourcesViewController
        
        self.fetchedResultsControllerDataSourceEvents = [[VIFetchedResultsControllerDataSource alloc] initWithFetchedResultsController:fetchedResultsController tableView:self.tableView cellIdentifier:@"eventCell" configureCellBlock:configureCellBlock];
    }
    return _fetchedResultsControllerDataSourceEvents;
}


@end
