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


@property (strong, nonatomic) NSMutableDictionary *sectionsDictionary;
@property (strong, nonatomic) NSArray *sectionsArray;
@property (strong, nonatomic) NSDateFormatter *sectionDateFormatter;


- (IBAction)refreshControlValueChanged:(id)sender;
- (void)groupFetchedItemsByWeek;

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
	
	// set Date Formatter
	self.sectionDateFormatter = [[NSDateFormatter alloc] init];
	[self.sectionDateFormatter setDateStyle:NSDateFormatterMediumStyle];
	[self.sectionDateFormatter setTimeStyle:NSDateFormatterNoStyle];
	
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
	
	[self groupFetchedItemsByWeek];
}


- (void)setDisplayMode:(UHDNewsListDisplayMode)displayMode
{
	_displayMode = displayMode;
	
	[self groupFetchedItemsByWeek];
	
    [self.tableView reloadData];
}


#pragma mark - User Interaction

- (IBAction)refreshControlValueChanged:(UIRefreshControl *)sender
{
    [[[UHDRemoteDatasourceManager defaultManager] remoteDatasourceForKey:UHDRemoteDatasourceKeyNews] refreshWithCompletion:^(BOOL success, NSError *error) {
        [sender endRefreshing];
    }];
	// TODO: Refreshing throws an exception
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showNewsDetail"]) {
        
        UHDNewsDetailViewController *newsDetailVC = segue.destinationViewController;
		
		NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
		NSArray *items = [self.sectionsDictionary objectForKey:self.sectionsArray[indexPath.section]];
		UHDNewsItem *item = items[indexPath.row];
		
		//UHDNewsItem *item = self.fetchedResultsControllerDataSource.selectedItem;
		
		// Mark item as read
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
		[fetchRequest setIncludesSubentities:NO];
		
		// Idea: write custom comparator for sorting items by calendar week
		/*
		NSComparator compareDatesByWeekOfYear = ^(id date1, id date2) {
		
			NSCalendar *calendar = [NSCalendar currentCalendar];
			NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
			[calendar setTimeZone:timeZone];
			
			NSDateComponents *weekComponents1 = [calendar components: NSCalendarUnitYear | NSCalendarUnitWeekOfYear fromDate:date1];
			NSDateComponents *weekComponents2 = [calendar components: NSCalendarUnitYear | NSCalendarUnitWeekOfYear fromDate:date2];
			
			NSDate *dateRepresentingDate1 = [calendar dateFromComponents:weekComponents1];
			NSDate *dateRepresentingDate2 = [calendar dateFromComponents:weekComponents2];
			
			return [dateRepresentingDate1 compare:dateRepresentingDate2];

		};
		*/

        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
        
        NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        
		VIFetchedResultsControllerDataSource *fetchedResultsControllerDataSource = [[VIFetchedResultsControllerDataSource alloc] init];
		fetchedResultsControllerDataSource.tableView = self.tableView;
		fetchedResultsControllerDataSource.fetchedResultsController = fetchedResultsController;
		self.fetchedResultsControllerDataSourceNews = fetchedResultsControllerDataSource;
		
    }
	
	/*
	NSArray *sections = _fetchedResultsControllerDataSourceNews.fetchedResultsController.sections;
	[self.logger log:[NSString stringWithFormat:@"number of sections: %lu", [sections count]] forLevel:VILogLevelDebug];
	*/
	
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
	//return [self.fetchedResultsControllerDataSource numberOfSectionsInTableView:tableView];
	
	return [self.sectionsArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	//return [self.fetchedResultsControllerDataSource tableView:tableView numberOfRowsInSection:section];
	
	return [[self.sectionsDictionary objectForKey:self.sectionsArray[section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = nil;
	
	NSArray *items = [self.sectionsDictionary objectForKey:self.sectionsArray[indexPath.section]];

	if (self.displayMode == UHDNewsListDisplayModeNews) {

        static NSString *newsCellIdentifier = @"newsCell";

        //UHDNewsItem *item = [self.fetchedResultsControllerDataSource.fetchedResultsController objectAtIndexPath:indexPath];
		
		UHDNewsItem *item = items[indexPath.row];
	
        cell = [tableView dequeueReusableCellWithIdentifier:newsCellIdentifier forIndexPath:indexPath];
		[(UHDNewsItemCell *)cell configureForItem:item];
	
	}
	else {
	
		//UHDEventItem *item = [self.fetchedResultsControllerDataSource.fetchedResultsController objectAtIndexPath:indexPath];
		
		UHDEventItem *item = items[indexPath.row];
		
		if ([[item entityName] isEqualToString:[UHDEventItem entityName]]) {
			cell = [tableView dequeueReusableCellWithIdentifier:@"eventCell" forIndexPath:indexPath];
			[(UHDEventItemCell *)cell configureForItem:item];
		}
		else {
			cell = [tableView dequeueReusableCellWithIdentifier:@"talkCell" forIndexPath:indexPath];
			[(UHDTalkItemCell *)cell configureForItem:(UHDTalkItem *)item];
		}
	}
	return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	// Use user's current calendar and time zone
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
	[calendar setTimeZone:timeZone];
	
	NSDate *startDate = self.sectionsArray[section];
	
	NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
	[dateComponents setWeekOfYear:1];
	[dateComponents setDay:-1];
	
	NSDate *endDate = [calendar dateByAddingComponents:dateComponents toDate:startDate options:0];
	
	NSString *startDateString = [self.sectionDateFormatter stringFromDate:startDate];
	NSString *endDateString = [self.sectionDateFormatter stringFromDate:endDate];
	
	
	NSString *sectionHeader = [NSString stringWithFormat:@"%@ - %@", startDateString, endDateString];
	
	return sectionHeader;
	
	//return [self.fetchedResultsControllerDataSource tableView:tableView titleForHeaderInSection:section];
}


# pragma mark - Table View Section Headers


- (NSDate *)dateOfBeginningCalendarWeekForDate: (NSDate *)date {
	
	// Use user's current calendar and time zone
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
	[calendar setTimeZone:timeZone];
	
	NSDateComponents *dateComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitYearForWeekOfYear | NSCalendarUnitWeekOfYear fromDate:date];
	
	NSDate *beginningOfCalendarWeek = [calendar dateFromComponents:dateComponents];
	
	// Add one day to let week start on Monday: can cause trouble when item's date is Sunday
	/*
	NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
	[dayComponent setDay:1];
	beginningOfCalendarWeek = [calendar dateByAddingComponents:dayComponent toDate:beginningOfCalendarWeek options:0];
	*/
	
	
	/*
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
	[self.logger log:[NSString stringWithFormat:@"test date: %@", [dateFormatter stringFromDate:beginningOfCalendarWeek]] forLevel:VILogLevelDebug];
	*/
	
	return beginningOfCalendarWeek;
}


- (void)groupFetchedItemsByWeek {

	self.sectionsDictionary = [[NSMutableDictionary alloc] init];
	
	// Use user's current calendar and time zone
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
	[calendar setTimeZone:timeZone];
	
	/*
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
	*/
	
	for (UHDNewsItem *item in self.fetchedResultsControllerDataSource.fetchedResultsController.fetchedObjects) {
	
		//[self.logger log:[NSString stringWithFormat:@"date of news item: %@", [dateFormatter stringFromDate:item.date]] forLevel:VILogLevelDebug];
		
		NSDate *week = [self dateOfBeginningCalendarWeekForDate:item.date];
		
		//[self.logger log:[NSString stringWithFormat:@"week of news item: %@", [dateFormatter stringFromDate:week]] forLevel:VILogLevelDebug];
		
		NSMutableArray *items = [self.sectionsDictionary objectForKey:week];
		if (items == nil) {
			items = [NSMutableArray arrayWithObject:item];
			[self.sectionsDictionary setObject:items forKey:week];
		}
		else {
			[[self.sectionsDictionary objectForKey:week] addObject:item];
		}
		
	};
	
	NSArray *weeks = [self.sectionsDictionary allKeys];
	
	NSArray *sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:NO] ];
	
	self.sectionsArray = [weeks sortedArrayUsingDescriptors:sortDescriptors];
	
	//[self.logger log:[NSString stringWithFormat:@"number of weeks: %lu", [weeks count]] forLevel:VILogLevelDebug];

}


@end
