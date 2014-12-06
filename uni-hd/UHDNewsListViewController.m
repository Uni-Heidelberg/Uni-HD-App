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


typedef enum : NSUInteger {
    UHDNewsDatePeriodLaterOrEarlier = 0,
    UHDNewsDatePeriodNext7Days,
    UHDNewsDatePeriodTomorrow,
    UHDNewsDatePeriodToday,
    UHDNewsDatePeriodYesterday,
    UHDNewsDatePeriodLast7Days,
} UHDNewsDatePeriod;


@interface UHDNewsListViewController ()

@property (strong, nonatomic, readonly) VIFetchedResultsControllerDataSource *fetchedResultsControllerDataSource;
@property (strong, nonatomic) VIFetchedResultsControllerDataSource *fetchedResultsControllerDataSourceNews;
@property (strong, nonatomic) VIFetchedResultsControllerDataSource *fetchedResultsControllerDataSourceEvents;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) NSDateFormatter *sectionDateFormatter;

- (IBAction)refreshControlValueChanged:(id)sender;

@end


// category on UHDNewsItem
@interface UHDNewsItem (Sectioning)

@property (nonatomic, readonly) NSDate *reducedDate;

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
	
	// set date format
	self.sectionDateFormatter = [[NSDateFormatter alloc] init];
	[self.sectionDateFormatter setDateFormat:@"MMMM yyyy"];
	
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
	// TODO: Refreshing throws an exception
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showNewsDetail"]) {
        
        UHDNewsDetailViewController *newsDetailVC = segue.destinationViewController;
		
		UHDNewsItem *item = self.fetchedResultsControllerDataSource.selectedItem;
		
		// Mark item as read
		item.read = YES;
        [item.managedObjectContext saveToPersistentStore:NULL];
        
        newsDetailVC.newsItem = item;
    }
	else if ([segue.identifier isEqualToString:@"showEventDetail"]) {
	
		UHDNewsDetailViewController *newsDetailVC = segue.destinationViewController;
        
        UHDEventItem *item = self.fetchedResultsControllerDataSource.selectedItem;
		
		//item.read = YES;
        //[item.managedObjectContext saveToPersistentStore:NULL];
        
        newsDetailVC.newsItem = item;
	
	}
	else if ([segue.identifier isEqualToString:@"showTalkDetail"]) {
		UHDNewsDetailViewController *newsDetailVC = segue.destinationViewController;
        
        UHDTalkItem *item = self.fetchedResultsControllerDataSource.selectedItem;
		
		//item.read = YES;
        //[item.managedObjectContext saveToPersistentStore:NULL];
        
        newsDetailVC.newsItem = item;
	}
}


#pragma mark - Data Source

- (VIFetchedResultsControllerDataSource *)fetchedResultsControllerDataSource
{
    if (self.displayMode == UHDNewsListDisplayModeNews) {
		return self.fetchedResultsControllerDataSourceNews;
	} else {
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
        
        NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"reducedDate" cacheName:nil];
        
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
        
        NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"reducedDate" cacheName:nil];
        
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
	
	//return [self.sectionsArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.fetchedResultsControllerDataSource tableView:tableView numberOfRowsInSection:section];
	
	//return [[self.sectionsDictionary objectForKey:self.sectionsArray[section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = nil;
	
	//NSArray *items = [self.sectionsDictionary objectForKey:self.sectionsArray[indexPath.section]];

	if (self.displayMode == UHDNewsListDisplayModeNews) {

        static NSString *newsCellIdentifier = @"newsCell";

        UHDNewsItem *item = [self.fetchedResultsControllerDataSource.fetchedResultsController objectAtIndexPath:indexPath];
		
		//UHDNewsItem *item = items[indexPath.row];
	
        cell = [tableView dequeueReusableCellWithIdentifier:newsCellIdentifier forIndexPath:indexPath];
		[(UHDNewsItemCell *)cell configureForItem:item];
	
	}
	else {
	
		UHDEventItem *item = [self.fetchedResultsControllerDataSource.fetchedResultsController objectAtIndexPath:indexPath];
		
		//UHDEventItem *item = items[indexPath.row];
		
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
	NSDate *date = [(UHDNewsItem *)[[(id<NSFetchedResultsSectionInfo>)[self.fetchedResultsControllerDataSource.fetchedResultsController.sections objectAtIndex:section] objects] firstObject] date];
	
	UHDNewsDatePeriod datePeriod = [self datePeriodForDate:date];
	
	switch (datePeriod) {
        case UHDNewsDatePeriodLast7Days:
            return NSLocalizedString(@"Letzte 7 Tage", nil);
        case UHDNewsDatePeriodYesterday:
            return NSLocalizedString(@"Gestern", nil);
        case UHDNewsDatePeriodToday:
            return NSLocalizedString(@"Heute", nil);
        case UHDNewsDatePeriodTomorrow:
            return NSLocalizedString(@"Morgen", nil);
        case UHDNewsDatePeriodNext7Days:
            return NSLocalizedString(@"Nächste 7 Tage", nil);
        case UHDNewsDatePeriodLaterOrEarlier:
            return [self.sectionDateFormatter stringFromDate:date];
            
        default:
            return nil;
            break;
	}

}


# pragma mark - Sectioning

- (UHDNewsDatePeriod)datePeriodForDate: (NSDate *)date {

    NSCalendar *calendar = [NSCalendar currentCalendar];
	NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
	[calendar setTimeZone:timeZone];
	
    NSDate *reducedDate = [calendar dateBySettingHour:0 minute:0 second:0 ofDate:date options:0];
    NSDate *today = [calendar dateBySettingHour:0 minute:0 second:0 ofDate:[NSDate date] options:0];
    
    NSInteger daysFromNow = [calendar components:NSCalendarUnitDay fromDate:today toDate:reducedDate options:0].day;
    switch (daysFromNow) {
        case 1: return UHDNewsDatePeriodTomorrow;
        case 0: return UHDNewsDatePeriodToday;
        case -1: return UHDNewsDatePeriodYesterday;
        default:
            if (ABS(daysFromNow) > 7) {
                return UHDNewsDatePeriodLaterOrEarlier;
            } else if (daysFromNow < -1) {
                return UHDNewsDatePeriodLast7Days;
            } else if (daysFromNow > 1) {
                return UHDNewsDatePeriodNext7Days;
            }
            return UHDNewsDatePeriodLaterOrEarlier;
    }
}


@end


@implementation UHDNewsItem (Sectioning)

- (NSDate *)reducedDate {
	
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
	[calendar setTimeZone:timeZone];
	
	NSDate *reducedDate = [calendar dateBySettingHour:0 minute:0 second:0 ofDate:self.date options:0];
	NSDate *today = [calendar dateBySettingHour:0 minute:0 second:0 ofDate:[NSDate date] options:0];
	
	NSInteger daysFromNow = [calendar components:NSCalendarUnitDay fromDate:today toDate:reducedDate options:0].day;
	

	if (ABS(daysFromNow) <= 1) {
	// corresponding to 'today', 'yesterday' or 'tomorrow'
		return reducedDate;
	}
	
	NSDateComponents *reducedDateComponents;
	
	if (ABS(daysFromNow) > 7) {
	// corresponding to 'earlier' or 'later'
	
		reducedDateComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:reducedDate];
		reducedDate = [calendar dateFromComponents:reducedDateComponents];
	}
	else {
	// corresponding to 'next 7 days' or 'last 7 days'
	
		// add +/- 7 days to today
		NSDateComponents *days = [[NSDateComponents alloc] init];
		if (daysFromNow > 0) {
			days.day = 7;
		}
		else {
			days.day = -7;
		}
		reducedDate = [calendar dateByAddingComponents:days toDate:today options:0];
	}
	
	return reducedDate;
}

@end
