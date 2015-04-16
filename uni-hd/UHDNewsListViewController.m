//
//  UHDNewsListViewController.m
//  uni-hd
//
//  Created by Nils Fischer on 20.06.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDNewsListViewController.h"

#import "VIFetchedResultsControllerDataSource.h"
@import UHDRemoteKit;
#import <UHDKit/UHDKit-Swift.h>
#import "NSManagedObject+VIInsertIntoContextCategory.h"

// View Controllers
#import "UHDNewsDetailWebViewController.h"
#import "UHDTalkDetailViewController.h"

// Table View Cells
#import "UHDNewsItemCell.h"
#import "UHDEventItemCell.h"
#import "UHDTalkItemCell.h"
#import "UHDTalkSpeaker.h"


@interface UHDNewsListViewController ()

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) VIFetchedResultsControllerDataSource *fetchedResultsControllerDataSource;

@property (strong, nonatomic) NSDateFormatter *sectionDateFormatter;

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *headerViewLabel;


- (IBAction)refreshControlValueChanged:(id)sender;

//@property (strong, nonatomic) NSMutableDictionary *tableViewRowHeightCache;

@end



@implementation UHDNewsListViewController


- (void)awakeFromNib {
    [super awakeFromNib];
	[self.tableView registerNib:[UINib nibWithNibName:@"NewsItemCell" bundle:[NSBundle bundleForClass:[UHDNewsItemCell class]]] forCellReuseIdentifier:@"newsCell"];
	[self.tableView registerNib:[UINib nibWithNibName:@"EventItemCell" bundle:[NSBundle bundleForClass:[UHDEventItemCell class]]] forCellReuseIdentifier:@"eventCell"];
	[self.tableView registerNib:[UINib nibWithNibName:@"TalkItemCell" bundle:[NSBundle bundleForClass:[UHDTalkItemCell class]]] forCellReuseIdentifier:@"talkCell"];
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	// layout already accomplished after creation of NewsListVC in 'viewControllerAtIndex' method of NewsVC
	
	/*
	// force immediate layout of subviews
	[self.tableView layoutIfNeeded];
	*/
	
	/*
    // prevent visible layout corrections after initial appearence of the VC
	dispatch_async(dispatch_get_main_queue(), ^{
		//[self.tableView layoutIfNeeded];
        [self.tableView reloadData];
	});
	*/
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 160;
	
	self.tableView.dataSource = self;
	self.tableView.delegate = self;
	
	// set date format
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
	[calendar setTimeZone:timeZone];
	self.sectionDateFormatter = [[NSDateFormatter alloc] init];
	[self.sectionDateFormatter setCalendar:calendar];
	NSString *formatTemplate = [NSDateFormatter dateFormatFromTemplate:@"MMMM YYYY" options:0 locale:[NSLocale currentLocale]];
	[self.sectionDateFormatter setDateFormat:formatTemplate];
	
	[self configureView];
}


- (void)configureView {
	
	// configure table header View
	if ([self.fetchedResultsControllerDataSource.fetchedResultsController.fetchedObjects count] == 0)
	{
		switch (self.displayMode) {
			case UHDNewsEventsDisplayModeNews:
				self.headerViewLabel.text = NSLocalizedString(@"Es liegen keine News zum Anzeigen vor.", nil);
				break;
			case UHDNewsEventsDisplayModeEvents:
				self.headerViewLabel.text = NSLocalizedString(@"Es liegen keine Veranstaltungen zum Anzeigen vor.", nil);
				break;
			default:
				self.headerViewLabel.text = NSLocalizedString(@"Es liegen keine Daten zum Anzeigen vor.", nil);
				break;
		}
		self.tableView.tableHeaderView = self.headerView;
	}
	else
	{
		self.tableView.tableHeaderView = nil;
	}
	
	// force table view layout to prevent visible layout corrections after initial appearance of the VC
	[self.tableView layoutIfNeeded];
	
}


- (void)setSources:(NSArray *)sources
{
    _sources = sources;
    self.managedObjectContext = [(NSManagedObject *)[sources firstObject] managedObjectContext];
	
	/*
    if (!self.title && self.sources.count > 0) {
        self.title = [sources[0] title];
    }
	*/
	
	switch (self.displayMode) {
		case UHDNewsEventsDisplayModeNews:
			self.fetchedResultsControllerDataSource.fetchedResultsController.fetchRequest.predicate = [NSPredicate predicateWithFormat:@"source IN %@", self.sources];
			break;
		case UHDNewsEventsDisplayModeEvents:
			self.fetchedResultsControllerDataSource.fetchedResultsController.fetchRequest.predicate = [NSPredicate predicateWithFormat:@"(source IN %@) AND (date >= %@)", self.sources, [NSDate date]];
			break;
		default:
			self.fetchedResultsControllerDataSource.fetchedResultsController.fetchRequest.predicate = [NSPredicate predicateWithFormat:@"source IN %@", self.sources];
			break;
	}
	
	[self.fetchedResultsControllerDataSource reloadData];
	[self configureView];
}


- (void)setDisplayMode:(UHDNewsEventsDisplayMode)displayMode
{
	_displayMode = displayMode;
	
	[self updateFetchedResultsControllerForChangedDisplayMode];
	[self configureView];
	
    [self.tableView reloadData];
}


#pragma mark - User Interaction

- (IBAction)refreshControlValueChanged:(UIRefreshControl *)sender
{
    [[[UHDRemoteDatasourceManager defaultManager] remoteDatasourceForKey:[UHDConstants remoteDatasourceKeyNews]] refreshWithCompletion:^(BOOL success, NSError *error) {
        [sender endRefreshing];
    }];
	// TODO: Refreshing throws an exception
}

/*
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
        
        newsDetailVC.newsItem = item;
	
	}
	else if ([segue.identifier isEqualToString:@"showTalkDetail"]) {
		UHDTalkDetailViewController *talkDetailVC = segue.destinationViewController;
        
        UHDTalkItem *item = self.fetchedResultsControllerDataSource.selectedItem;
        
        talkDetailVC.talkItem = item;
	}
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"news" bundle:[NSBundle bundleForClass:[self class]]];
	
	NSManagedObject *item = self.fetchedResultsControllerDataSource.selectedItem;
	
	if ([item class] == [UHDNewsItem class]) {
		UHDNewsItem *newsItem = (UHDNewsItem *)item;
		
		// Mark item as read
		newsItem.read = YES;
		[newsItem.managedObjectContext saveToPersistentStore:NULL];
		
		// TODO: decide whether to use NewsDetailViewController or NewsDetailWebViewController
	
		//UHDNewsDetailWebViewController *newsDetailVC = [storyboard instantiateViewControllerWithIdentifier:@"newsDetailWeb"];
		NewsDetailViewController *newsDetailVC = [storyboard instantiateViewControllerWithIdentifier:@"newsDetail"];
		
		/*
		// test layout with image
		UIImage *image = [UIImage imageNamed:@"kip" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
		NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
		newsItem.imageData = imageData;
		*/
		
		newsDetailVC.newsItem = newsItem;
	
		[self.navigationController pushViewController:newsDetailVC animated:YES];
	}
	else if ([item class] == [UHDEventItem class]) {
		UHDNewsDetailWebViewController *newsDetailVC = [storyboard instantiateViewControllerWithIdentifier:@"newsDetailWeb"];
        
        newsDetailVC.newsItem = (UHDEventItem *)item;
		
		[self.navigationController pushViewController:newsDetailVC animated:YES];
	}
	else if ([item class] == [UHDTalkItem class]) {
		UHDTalkDetailViewController *talkDetailVC = [storyboard instantiateViewControllerWithIdentifier:@"talkDetail"];
        
        talkDetailVC.talkItem = (UHDTalkItem *)item;
		
		[self.navigationController pushViewController:talkDetailVC animated:YES];
	}
}


- (void)scrollToToday{
	
	if ([self.fetchedResultsControllerDataSource.fetchedResultsController.sections count] == 0) {
		return;
	}
	
	NSInteger sectioningPeriod;
	NSInteger nearestFutureValue = NSIntegerMax;
	id<NSFetchedResultsSectionInfo> nearestFutureSection = nil;
	
	for (id<NSFetchedResultsSectionInfo> section in self.fetchedResultsControllerDataSource.fetchedResultsController.sections) {
		sectioningPeriod = [[section name] integerValue] % 100;
		if ( (sectioningPeriod < NSIntegerMax) && (sectioningPeriod >= UHDSectioningPeriodToday)) {
			nearestFutureValue = sectioningPeriod;
			nearestFutureSection = section;
		}
	}

	NSIndexPath *indexPath;
	NSUInteger sectionIndex;
	
	if (nearestFutureSection != nil) {
		indexPath = [self.fetchedResultsControllerDataSource.fetchedResultsController indexPathForObject:[nearestFutureSection.objects firstObject]];
		sectionIndex = [self.fetchedResultsControllerDataSource.fetchedResultsController.sections indexOfObject:nearestFutureSection];
	}
	else {
		indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
		sectionIndex = 0;
	}
	
	[self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
	
	/*
	UHDNewsItemCell *cell;
	NSIndexPath *tempIndexPath;
	for (UHDNewsItem *item in self.fetchedResultsControllerDataSource.fetchedResultsController.fetchedObjects) {
		tempIndexPath = [self.fetchedResultsControllerDataSource.fetchedResultsController indexPathForObject:item];
		cell = (UHDNewsItemCell *) [self.tableView cellForRowAtIndexPath:tempIndexPath];
	}
	*/
	
	//[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
	
	/*
	double delayInSeconds = 0.1;
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
	dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
		[self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
	});
	*/
	
	// TODO: scrolling to today only works properly if 'cell for row at index path' has been called for today's cells
}


/*
-(NSMutableDictionary *)tableViewRowHeightCache {
	
	if (_tableViewRowHeightCache != nil) {
		NSMutableDictionary * tableViewRowHeightCache = [[NSMutableDictionary alloc] init];
		
		UITableViewCell *cell;
		NSIndexPath *indexPath;
		for (UHDNewsItem *item in self.fetchedResultsControllerDataSource.fetchedResultsController.fetchedObjects) {
		indexPath = [self.fetchedResultsControllerDataSource.fetchedResultsController indexPathForObject:item];
		cell = [self.tableView cellForRowAtIndexPath:indexPath];
		CGFloat height = cell.bounds.size.height;
		[tableViewRowHeightCache setValue:[NSString stringWithFormat:@"%f", height] forKey:[NSString stringWithFormat:@"%lu-%lu", indexPath.section, indexPath.row]];
		}
		
		_tableViewRowHeightCache = tableViewRowHeightCache;
	}
	
	return _tableViewRowHeightCache;
}
*/


// did this help ?	-> after many trials I imagined yes...

/*- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {

	UHDNewsItem *item = [self.fetchedResultsControllerDataSource.fetchedResultsController objectAtIndexPath:indexPath];
	if (item.image != nil) {
		return 200;
	}
	
	if ([[item entityName] isEqualToString:[UHDTalkItem entityName]]) {
		if ([((UHDTalkItem *) item).speaker.name length] > 1) {
			if ([item.abstract length] > 5) {
				return 210;
			}
			else {
				return 120;
			}
		}
		else {
			return 80;
		}
	}
	
	if ([item.abstract length] < 5) {
		return 80;
	}
	
	return 160;
}*/


#pragma mark - Data Source


- (VIFetchedResultsControllerDataSource *)fetchedResultsControllerDataSource
{
	if (!_fetchedResultsControllerDataSource)
    {
        if (!self.managedObjectContext) {
            [self.logger log:@"Unable to create fetched results controller without a managed object context" forLevel:VILogLevelWarning];
            return nil;
        }
		
		NSFetchRequest *fetchRequest;
		
		switch (self.displayMode) {
			case UHDNewsEventsDisplayModeNews:
				fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[UHDNewsItem entityName]];
				[fetchRequest setIncludesSubentities:NO];
				[fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]]];
				break;
			case UHDNewsEventsDisplayModeEvents:
				fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[UHDEventItem entityName]];
				[fetchRequest setIncludesSubentities:YES];
				[fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]]];
				break;
			default:
				fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[UHDNewsItem entityName]];
				[fetchRequest setIncludesSubentities:YES];
				[fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]]];
				break;
		}
		
        NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"sectionIdentifier" cacheName:nil];
        
		VIFetchedResultsControllerDataSource *fetchedResultsControllerDataSource = [[VIFetchedResultsControllerDataSource alloc] init];
		fetchedResultsControllerDataSource.tableView = self.tableView;
		fetchedResultsControllerDataSource.fetchedResultsController = fetchedResultsController;
		_fetchedResultsControllerDataSource = fetchedResultsControllerDataSource;
		
		//[self.logger log:[NSString stringWithFormat:@"number of fetched objects: %lu", [fetchedResultsController.fetchedObjects count]] forLevel:VILogLevelDebug];
		
	}
	
	/*
	NSArray *sections = _fetchedResultsControllerDataSource.fetchedResultsController.sections;
	for (id<NSFetchedResultsSectionInfo> section in sections) {
		[self.logger log:[NSString stringWithFormat:@"sectionID: %@", [section name]] forLevel:VILogLevelDebug];
		[self.logger log:[NSString stringWithFormat:@"object: %@", [[[section objects] firstObject] title]] forLevel:VILogLevelDebug];
	}
	*/
	
	return _fetchedResultsControllerDataSource;
}


- (void)updateFetchedResultsControllerForChangedDisplayMode {

    if (self.managedObjectContext) {
        NSFetchRequest *fetchRequest = self.fetchedResultsControllerDataSource.fetchedResultsController.fetchRequest;
		
		NSEntityDescription *entityDescription;
		
		switch (self.displayMode) {
			case UHDNewsEventsDisplayModeNews:
				entityDescription = [NSEntityDescription entityForName:[UHDNewsItem entityName] inManagedObjectContext:self.managedObjectContext];
				[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"source IN %@", self.sources]];
				[fetchRequest setIncludesSubentities:NO];
				[fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]]];
				break;
			case UHDNewsEventsDisplayModeEvents:
				entityDescription = [NSEntityDescription entityForName:[UHDEventItem entityName] inManagedObjectContext:self.managedObjectContext];
				[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"(source IN %@) AND (date >= %@)", self.sources, [NSDate date]]];
				[fetchRequest setIncludesSubentities:YES];
				[fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]]];
				break;
			default:
				entityDescription = [NSEntityDescription entityForName:[UHDNewsItem entityName] inManagedObjectContext:self.managedObjectContext];
				[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"source IN %@", self.sources]];
				[fetchRequest setIncludesSubentities:YES];
				[fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]]];
				break;
		}
		
        [fetchRequest setEntity:entityDescription];
        
        [self.fetchedResultsControllerDataSource reloadData];
    }
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
	
	UHDNewsItem *item = [self.fetchedResultsControllerDataSource.fetchedResultsController objectAtIndexPath:indexPath];

	if ([item.entityName isEqualToString:[UHDNewsItem entityName]]) {
	
		cell = [tableView dequeueReusableCellWithIdentifier:@"newsCell" forIndexPath:indexPath];
		[(UHDNewsItemCell *)cell configureForItem:item];
		
	}
	else if ([item.entityName isEqualToString:[UHDEventItem entityName]]) {
		
		cell = [tableView dequeueReusableCellWithIdentifier:@"eventCell" forIndexPath:indexPath];
		[(UHDEventItemCell *)cell configureForEvent:(UHDEventItem *)item];
		
	}
	else if ([item.entityName isEqualToString:[UHDTalkItem entityName]]) {
	
		cell = [tableView dequeueReusableCellWithIdentifier:@"talkCell" forIndexPath:indexPath];
		[(UHDTalkItemCell *)cell configureForTalk:(UHDTalkItem *)item];
	
	}
	
	//cell.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
	
	//[self.logger log:[NSString stringWithFormat:@"height of cell: %f", cell.bounds.size.height] forLevel:VILogLevelDebug];
	
	return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	id <NSFetchedResultsSectionInfo> theSection = [[self.fetchedResultsControllerDataSource.fetchedResultsController sections] objectAtIndex:section];
	
	NSInteger sectionIdentifier = [[theSection name] integerValue];
	NSInteger year = sectionIdentifier / (100 * 100);
	NSInteger month = (sectionIdentifier / 100) - (year * 100);
	NSInteger sectioningPeriod = sectionIdentifier % 100;
	
	switch (sectioningPeriod) {
		case UHDSectioningPeriodToday:
			return NSLocalizedString(@"Heute", nil);
		case UHDSectioningPeriodTomorrow:
			return NSLocalizedString(@"Morgen", nil);
		case UHDSectioningPeriodYesterday:
			return NSLocalizedString(@"Gestern", nil);
		case UHDSectioningPeriodNext7days:
			return NSLocalizedString(@"Nächste 7 Tage", nil);
		case UHDSectioningPeriodLast7days:
			return NSLocalizedString(@"Letzte 7 Tage", nil);
		default: {
			NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
			dateComponents.year = year;
			dateComponents.month = month;
			NSDate *sectionDate = [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
			return [self.sectionDateFormatter stringFromDate:sectionDate];
		}
	}
}

@end
