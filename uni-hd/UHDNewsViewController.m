//
//  UHDNewsViewController.m
//  uni-hd
//
//  Created by Nils Fischer on 06.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDNewsViewController.h"
#import "UHDAppDelegate.h"
#import "NSManagedObject+VIInsertIntoContextCategory.h"

// View Controllers
#import "UHDNewsSourcesViewController.h"
#import "UHDNewsListViewController.h"

// Model
#import "UHDNewsSource.h"
#import "UHDNewsItem.h"
#import	"UHDEventItem.h"
#import "UHDTalkItem.h"

// Sources Navigation Bar
#import "UHDNewsSourcesNavigationBar.h"


typedef enum : NSUInteger {
    UHDAllSourcesIndex = NSUIntegerMax,
} UHDSourceIndex;


@interface UHDNewsViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate, NSFetchedResultsControllerDelegate, UHDNewsSourcesNavigationBarDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) UIPageViewController *pageViewController;

//@property (strong, nonatomic) NSMutableArray *newsListViewControllers;

@property (strong, nonatomic) NSMutableArray *newsListViewControllerCache;

@property (weak, nonatomic) IBOutlet UHDNewsSourcesNavigationBar *sourcesNavigationBar;
@property (weak, nonatomic) IBOutlet UIButton *sourceButton;
@property (weak, nonatomic) IBOutlet UIView *titleView;

//@property (weak, nonatomic) IBOutlet UISegmentedControl *newsEventsSegmentedControl;

//- (IBAction)newsEventsSegmentedControlValueChanged:(id)sender;
- (IBAction)sourceButtonPressed:(id)sender;

@end


@implementation UHDNewsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    // TODO: fix scroll view insets & extend under both bars
    
    self.sourcesNavigationBar.delegate = self;
	
	// configuration is done in "embedPageVC" segue
	//[self configureViewForFetchedSources];
	
	// Is this necessary?
	// [self updateDisplayMode];
	
	[self updateSourceButton];
	
	//[self configureView];
	
	//[(UHDNewsListViewController *)self.pageViewController.viewControllers[0] scrollToToday];
}

/*
- (void)configureView
{
    // make sure only active table view scrolls to top
    for (UHDNewsListViewController *vc in self.newsListViewControllers) {
        vc.tableView.scrollsToTop = [self.pageViewController.viewControllers containsObject:vc];
    }
}
*/

- (void)configureViewForFetchedSources {

	// set currently subscribed sources to display in sources navigation bar
	self.sourcesNavigationBar.sources = [self.fetchedResultsController fetchedObjects];
}


- (void)updateViewForSelectedSource {
    // set currently selected source
	
	NSUInteger sourceIndex = [self sourceIndexForPageIndex:[(UHDNewsListViewController *)self.pageViewController.viewControllers[0] pageIndex]] ;
	if (sourceIndex == UHDAllSourcesIndex) {
		self.sourcesNavigationBar.selectedSource = nil;
	}
	else {
		self.sourcesNavigationBar.selectedSource = [self.sourcesNavigationBar.sources objectAtIndex:sourceIndex];
	}
	
	/*
	UHDNewsListViewController *allSourcesVC = self.newsListViewControllers[0];
	if (((UHDNewsListViewController *) self.pageViewController.viewControllers[0]) == allSourcesVC) {
		self.sourcesNavigationBar.selectedSource = nil;
	}
	else {
		UHDNewsSource *currentSource = ((UHDNewsListViewController *)self.pageViewController.viewControllers[0]).sources[0];
		self.sourcesNavigationBar.selectedSource = currentSource;
	}
	*/
	
	[self updateSourceButton];
}


#pragma mark - Fetched Results Controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (!_fetchedResultsController)
    {
        if (!self.managedObjectContext) {
            // FIXME: [self.logger log:@"Unable to create fetched results controller without a managed object context" forLevel:VILogLevelWarning];
            return nil;
        }
        
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[UHDNewsSource entityName]];
		
		switch (self.displayMode) {
			case UHDNewsEventsDisplayModeNews:
				//fetchRequest.predicate = [NSPredicate predicateWithFormat:@"(subscribed == YES) AND SUBQUERY(newsItems, $x, CAST($x, %@) != NULL).@count > 0", [UHDNewsItem entityName]];
				fetchRequest.predicate = [NSPredicate predicateWithFormat:@"(subscribed == YES) AND (isNewsSource == YES)"];
				break;
			case UHDNewsEventsDisplayModeEvents:
				//fetchRequest.predicate = [NSPredicate predicateWithFormat:@"(subscribed == YES) AND (SUBQUERY(newsItems, $x, $x.entity.name == %@ || $x.name == %@).@count != 0)", [UHDEventItem entityName], [UHDTalkItem entityName]];
				fetchRequest.predicate = [NSPredicate predicateWithFormat:@"(subscribed == YES) AND (isEventSource == YES)"];
				break;
			default:
				fetchRequest.predicate = [NSPredicate predicateWithFormat:@"subscribed == YES"];
				break;
		}
		
		
        fetchRequest.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"remoteObjectId" ascending:YES] ];
        
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        self.fetchedResultsController.delegate = self;
        [self.fetchedResultsController performFetch:NULL];
    }
    return _fetchedResultsController;
}


#pragma mark - User Interaction


- (IBAction)sourceButtonPressed:(id)sender {
	
	[self.sourcesNavigationBar scrollToSelectedSource];
	
}


- (void)setDisplayMode:(UHDNewsEventsDisplayMode)displayMode {

	_displayMode = displayMode;
	[self updateDisplayMode];
	
}


- (void)updateDisplayMode
{
	/*
	for (UHDNewsListViewController *newsListVC in self.newsListViewControlle) {
		newsListVC.displayMode = self.displayMode;
	}
	*/
	
	UHDNewsListViewController *newsListVC;
	for (int i = 0; i < [self.newsListViewControllerCache count]; i++) {
		if (self.newsListViewControllerCache[i] != [NSNull null]) {
			newsListVC = (UHDNewsListViewController *) self.newsListViewControllerCache[i];
			newsListVC.displayMode = self.displayMode;
		}
	}
	
}


- (void)updateSourceButton {
	
	UHDNewsSource *source = self.sourcesNavigationBar.selectedSource;
	
	if (source == nil) {
		switch (self.displayMode) {
			case UHDNewsEventsDisplayModeNews:
				[self.sourceButton setTitle:NSLocalizedString(@"Alle News", nil) forState:UIControlStateNormal];
				break;
			case UHDNewsEventsDisplayModeEvents:
				[self.sourceButton setTitle:NSLocalizedString(@"Alle Veranstaltungen", nil) forState:UIControlStateNormal];
				break;
			default:
				[self.sourceButton setTitle:NSLocalizedString(@"Alle News und Veranstaltungen", nil) forState:UIControlStateNormal];
				break;
		}
	}
	else {
		[self.sourceButton setTitle:source.title forState:UIControlStateNormal];
	}
	
	self.sourceButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
	self.sourceButton.titleLabel.textAlignment = NSTextAlignmentCenter;
	self.sourceButton.titleLabel.numberOfLines = 2;
	
	self.titleView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	
	[self.sourceButton sizeToFit];
}

/*
- (IBAction)todayButtonPressed:(id)sender {
	
	[self.pageViewController.viewControllers[0] scrollToToday];
}
*/


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showSources"]) {
        UHDNewsSourcesViewController *newsSourcesVC = (UHDNewsSourcesViewController *)[(UINavigationController *)segue.destinationViewController topViewController];
        newsSourcesVC.managedObjectContext = self.managedObjectContext;
    } else if ([segue.identifier isEqualToString:@"embedPageVC"]) {
        self.pageViewController = segue.destinationViewController;
        self.pageViewController.dataSource = self;
        self.pageViewController.delegate = self;
		
        //[self.pageViewController setViewControllers:@[ self.newsListViewControllers[0] ] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
		
		// must be called prior to displaying the view (even before view did load)
		[self configureViewForFetchedSources];
		
		[self.pageViewController setViewControllers:@[ [self viewControllerAtIndex:0] ] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    }
}


#pragma mark - Sources Navigation Bar Delegate
/*
- (void)sourcesNavigationBar:(UHDNewsSourcesNavigationBar *)navigationBar didSelectSource:(UHDNewsSource *)source
{
    // FIXME: [self.logger log:[NSString stringWithFormat:@"Switch Page View Controller to Source: %@", source.title] forLevel:VILogLevelDebug];
	
    NSUInteger currentSourceIndex = [self.newsListViewControllers indexOfObject:self.pageViewController.viewControllers[0]];
    NSUInteger selectedSourceIndex = 0;
    
    UHDNewsListViewController *selectedNewsListVC = nil;
    if (source != nil) {
        for (int i=1; i<self.newsListViewControllers.count; i++) {
            UHDNewsListViewController *newsListVC = self.newsListViewControllers[i];
            if ([newsListVC.sources containsObject:source]) {
                selectedNewsListVC = newsListVC;
                selectedSourceIndex = [self.newsListViewControllers indexOfObject:selectedNewsListVC];
                break;
            }
        }
    }
    if (selectedNewsListVC == nil) {
        selectedNewsListVC = self.newsListViewControllers[0];
        selectedSourceIndex = 0;
    }

    UIPageViewControllerNavigationDirection navigationDirection = (selectedSourceIndex > currentSourceIndex) ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse;
    
    [self.pageViewController setViewControllers:@[ selectedNewsListVC ] direction:navigationDirection animated:YES completion:nil];
	[self updateSourceButton];
	[selectedNewsListVC scrollToToday];
}
*/


- (void)sourcesNavigationBar:(UHDNewsSourcesNavigationBar *)navigationBar didSelectSource:(UHDNewsSource *)source
{
    // FIXME: [self.logger log:[NSString stringWithFormat:@"Switch Page View Controller to Source: %@", source.title] forLevel:VILogLevelDebug];
	
	NSUInteger selectedSourceIndex, selectedPageIndex;
	if (source == nil) {
		selectedSourceIndex = UHDAllSourcesIndex;
		selectedPageIndex = 0;
	}
	else {
		selectedSourceIndex = [self.sourcesNavigationBar.sources indexOfObject:source];
		selectedPageIndex = selectedSourceIndex + 1;
	}
	
	UHDNewsListViewController *selectedNewsListVC = [self viewControllerAtIndex:selectedPageIndex];
	
    NSUInteger currentSourceIndex = [self sourceIndexForPageIndex:[(UHDNewsListViewController *) self.pageViewController.viewControllers[0] pageIndex]];
	
	UIPageViewControllerNavigationDirection navigationDirection;
	if (selectedSourceIndex == UHDAllSourcesIndex) {
		navigationDirection = UIPageViewControllerNavigationDirectionReverse;
	}
	else if (currentSourceIndex == UHDAllSourcesIndex) {
		navigationDirection = UIPageViewControllerNavigationDirectionForward;
	}
	else {
		navigationDirection = (selectedSourceIndex > currentSourceIndex) ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse;
	}
    
    [self.pageViewController setViewControllers:@[ selectedNewsListVC ] direction:navigationDirection animated:YES completion:nil];
	
	[self updateSourceButton];
	//[selectedNewsListVC scrollToToday];
}


#pragma mark - Page View Controller Delegate

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    [self updateViewForSelectedSource];
	//[((UHDNewsListViewController *)self.pageViewController.viewControllers[0]) scrollToToday];	// looks strange...
}


#pragma mark - Page View Controller Datasource
/*
- (NSMutableArray *)newsListViewControllers
{
    if (!_newsListViewControllers) {
        NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
        UHDNewsListViewController *allSourcesVC = [self newsListViewControllerForSources:self.fetchedResultsController.fetchedObjects];
        allSourcesVC.title = NSLocalizedString(@"All News & Events", nil);
        [viewControllers addObject:allSourcesVC];
        for (UHDNewsSource *source in self.fetchedResultsController.fetchedObjects) {
            [viewControllers addObject:[self newsListViewControllerForSources:@[ source ]]];
        }
        _newsListViewControllers = viewControllers;
    }
    return _newsListViewControllers;
}


- (UHDNewsListViewController *)newsListViewControllerForSources:(NSArray *)sources
{
    UHDNewsListViewController *newsListVC = (UHDNewsListViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"newsList"];
	
    newsListVC.sources = sources;
    return newsListVC;
}
*/

/*
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger currentIndex = [self.newsListViewControllers indexOfObject:viewController];
    if (currentIndex == NSNotFound) {
        currentIndex = -1;
    }
    NSInteger nextIndex = currentIndex + 1;
    if (nextIndex >= self.newsListViewControllers.count) {
        return nil;
    }
    return self.newsListViewControllers[nextIndex];
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger currentIndex = [self.newsListViewControllers indexOfObject:viewController];
    if (currentIndex == NSNotFound) {
        currentIndex = 1;
    }
    NSInteger prevIndex = currentIndex - 1;
    if (prevIndex < 0) {
        return nil;
    }
    return self.newsListViewControllers[prevIndex];
}
*/


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger pageIndex = ((UHDNewsListViewController *) viewController).pageIndex;
    
    if ((pageIndex == 0) || (pageIndex == NSNotFound)) {
        return nil;
    }
    
    pageIndex--;
	
    return [self viewControllerAtIndex:pageIndex];
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger pageIndex = ((UHDNewsListViewController *) viewController).pageIndex;
    
    if (pageIndex == NSNotFound) {
        return nil;
    }
    
    pageIndex++;
	
    if (pageIndex == [self.sourcesNavigationBar.sources count] + 1) {
        return nil;
    }
	
    return [self viewControllerAtIndex:pageIndex];
}


- (NSMutableArray *)newsListViewControllerCache {

	if (!self.sourcesNavigationBar || !self.sourcesNavigationBar.sources) {
		return nil;
	}

	if (!_newsListViewControllerCache) {
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:[UHDNewsSource entityName]];
		NSUInteger sourcesCount = [self.managedObjectContext countForFetchRequest:fetchRequest error:nil];
		_newsListViewControllerCache = [NSMutableArray arrayWithCapacity:(sourcesCount + 1)];
		for (int i = 0; i < [self.sourcesNavigationBar.sources count] + 1; i++) {
			[_newsListViewControllerCache addObject:[NSNull null]];
		}
	}
	
	return _newsListViewControllerCache;
}


- (UHDNewsListViewController *)viewControllerAtIndex:(NSUInteger)pageIndex {
/*
	// make sure that cache is valid
	if ([self.fetchedResultsController.fetchedObjects count] == [self.sourcesNavigationBar.sources count]) {
	}
	else {
		self.newsListViewControllerCache = nil;
	}
*/
	if (self.newsListViewControllerCache && ([self.newsListViewControllerCache objectAtIndex:pageIndex] != [NSNull null])) {
		return [self.newsListViewControllerCache objectAtIndex:pageIndex];
	}

	NSArray *subscribedSources = self.sourcesNavigationBar.sources;
	
    if (pageIndex >= [subscribedSources count] + 1) {
        return nil;
    }
	
	NSUInteger sourceIndex = [self sourceIndexForPageIndex:pageIndex];
	
	NSArray *sources;
	if (sourceIndex == UHDAllSourcesIndex) {
		sources = subscribedSources;
	}
	else {
		sources = @[ [subscribedSources objectAtIndex:(sourceIndex)] ];
	}
    UHDNewsListViewController *newsListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"newsList"];
	newsListVC.sources = sources;
	newsListVC.displayMode = self.displayMode;
    newsListVC.pageIndex = pageIndex;
	
	// layout table view before displaying to prevent visible layout corrections after initial appearence of the VC
	[newsListVC.tableView layoutIfNeeded];
	
	// cache view controller
	[self.newsListViewControllerCache replaceObjectAtIndex:pageIndex withObject:newsListVC];
    
    return newsListVC;
}


- (NSUInteger)sourceIndexForPageIndex:(NSUInteger)pageIndex {
	if (pageIndex == 0) {
		return UHDAllSourcesIndex;
	}
	else {
		return pageIndex - 1;
	}
}


- (NSUInteger)pageIndexForSourceIndex:(NSUInteger)sourceIndex {
	if (sourceIndex == UHDAllSourcesIndex) {
		return 0;
	}
	else {
		return sourceIndex + 1;
	}
}


#pragma mark - Core Data Change Notification

/*- (void)managedObjectContextDidSave:(NSNotification *)notification
 {
 for (NSManagedObject *object in notification.userInfo[NSUpdatedObjectsKey]) {
 if ([object isKindOfClass:[UHDNewsSource class]]) {
 [self.fetchedResultsController reloadData];
 break;
 }
 }
 }*/

/*
- (void)controller:(NSFetchedResultsController*)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath*)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath*)newIndexPath
{
    // TODO/BUG: subscribe source further right, then unsubscribe one left of it
    UHDNewsListViewController *allSourcesVC = (UHDNewsListViewController *)self.newsListViewControllers[0];
    NSInteger index = indexPath.item + 1;
    NSInteger newIndex = newIndexPath.item + 1;
    switch (type) {
        case NSFetchedResultsChangeInsert: {
            [allSourcesVC setSources:[allSourcesVC.sources arrayByAddingObject:anObject]];
            UHDNewsListViewController *sourceVC = [self newsListViewControllerForSources:@[ anObject ]];
            [self.newsListViewControllers insertObject:sourceVC atIndex:newIndex];
            break;
        }
        case NSFetchedResultsChangeMove: {
            UHDNewsListViewController *sourceVC = self.newsListViewControllers[index];
            [self.newsListViewControllers removeObjectAtIndex:index];
            [self.newsListViewControllers insertObject:sourceVC atIndex:newIndex];
            break;
        }
        case NSFetchedResultsChangeDelete: {
            UHDNewsListViewController *sourceVC = self.newsListViewControllers[index];
            if ([self.pageViewController.viewControllers containsObject:sourceVC]) {
                [self.pageViewController setViewControllers:@[ [self pageViewController:self.pageViewController viewControllerBeforeViewController:sourceVC] ] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
            }
            [self.newsListViewControllers removeObject:sourceVC];
            NSMutableArray *allSources = [allSourcesVC.sources mutableCopy];
            [allSources removeObject:anObject];
            [allSourcesVC setSources:allSources];
            break;
        }
        case NSFetchedResultsChangeUpdate:
        default:
            break;
    }
    [self.pageViewController setViewControllers:self.pageViewController.viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil]; // TODO: find better way to refresh neighbouring view controllers
	[self updateViewForSelectedSource];
	[self configureViewForFetchedSources];
}
*/


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	
	UHDNewsListViewController *currentVC = (UHDNewsListViewController *) self.pageViewController.viewControllers[0];
	if (currentVC == nil) {
		return;
	}
	NSUInteger currentSourceIndex = [self sourceIndexForPageIndex:[currentVC pageIndex]];
	
	NSUInteger sourceIndex = indexPath.row;
	NSUInteger newSourceIndex = newIndexPath.row;
	NSUInteger pageIndex = [self pageIndexForSourceIndex:sourceIndex];
	NSUInteger newPageIndex = [self pageIndexForSourceIndex:newSourceIndex];
	
	// copy subsribed sources into a mutable array to make the required changes
	NSMutableArray *sources = [[NSMutableArray alloc] initWithCapacity:([self.sourcesNavigationBar.sources count] + 1)];
	[sources addObjectsFromArray:self.sourcesNavigationBar.sources];
	
	// get 'All Sources VC' if currently displayed or in cache
	UHDNewsListViewController *allSourcesVC = nil;
	if (currentSourceIndex == UHDAllSourcesIndex) {
		allSourcesVC = currentVC;
	}
	else if ([self.newsListViewControllerCache objectAtIndex:[self pageIndexForSourceIndex:UHDAllSourcesIndex]] != [NSNull null]) {
		allSourcesVC = [self.newsListViewControllerCache objectAtIndex:[self pageIndexForSourceIndex:UHDAllSourcesIndex]];
	}
	
	switch (type) {
		case NSFetchedResultsChangeInsert: {
		
			// create a place in cache for the inserted source
			[self.newsListViewControllerCache insertObject:[NSNull null] atIndex:newPageIndex];
			
			// add inserted source to sources array
			[sources insertObject:anObject atIndex:newSourceIndex];
			
			// update 'All Sources VC'
			if (allSourcesVC) {
				allSourcesVC.sources = [NSArray arrayWithArray:sources];
				allSourcesVC.displayMode = self.displayMode;
			}
			
			/*
			// without caching, only the page index of the current VC has to be updated
			else if (newSourceIndex <= currentSourceIndex) {
				currentVC.pageIndex++;
			}
			*/
			
			// update page indices in cache (including current source)
			// i.e. increment page indices of all VC in cache after the inserted source
			NSUInteger viewControllerSourceIndex;
			UHDNewsListViewController *newsListVC;
			// start loop from i = 1 to exclude 'All Sources VC'
			for (int i = 1; i < [self.newsListViewControllerCache count]; i++) {
				if (self.newsListViewControllerCache[i] != [NSNull null]) {
					newsListVC = (UHDNewsListViewController *) self.newsListViewControllerCache[i];
					viewControllerSourceIndex = [self sourceIndexForPageIndex:newsListVC.pageIndex];
					if (viewControllerSourceIndex >= newSourceIndex) {
						newsListVC.pageIndex++;
					}
				}
			}
			
			break;
		}
		case NSFetchedResultsChangeDelete: {
		
			// delete source
			[self.newsListViewControllerCache removeObjectAtIndex:pageIndex];
			[sources removeObjectAtIndex:sourceIndex];
			
			// update 'All Sources VC'
			if (allSourcesVC) {
				allSourcesVC.sources = [NSArray arrayWithArray:sources];
				allSourcesVC.displayMode = self.displayMode;
			}
			
			/*
			// without caching, only the page index of the current VC has to be updated
			else if (currentSourceIndex > sourceIndex) {
				currentVC.pageIndex--;
			}
			*/
			
			// move one source to the left if currently displayed source is deleted
			if (currentSourceIndex == sourceIndex) {
			
				// 'selected source' needs a valid value if sources are reset
				self.sourcesNavigationBar.selectedSource = nil;
				
				// setting sources required for the 'viewControllerAtIndex' method to work
				self.sourcesNavigationBar.sources = [NSArray arrayWithArray:sources];
				
				// move on source to the left
				[self.pageViewController setViewControllers:@[ [self pageViewController:self.pageViewController viewControllerBeforeViewController:currentVC] ] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
				
				// select displayed source in navigation bar
				[self updateViewForSelectedSource];
			}
			
			// update page indices in cache (including current source)
			// i.e. decrement page indices of all VC in cache after the inserted source
			NSUInteger viewControllerSourceIndex;
			UHDNewsListViewController *newsListVC;
			for (int i = 1; i < [self.newsListViewControllerCache count]; i++) {
				if (self.newsListViewControllerCache[i] != [NSNull null]) {
					newsListVC = (UHDNewsListViewController *) self.newsListViewControllerCache[i];
					viewControllerSourceIndex = [self sourceIndexForPageIndex:newsListVC.pageIndex];
					if (viewControllerSourceIndex > sourceIndex) {
						newsListVC.pageIndex--;
					}
				}
			}
			
			break;
		}
		case NSFetchedResultsChangeMove: {
		
			// exchange objects
			[sources exchangeObjectAtIndex:sourceIndex withObjectAtIndex:newSourceIndex];
			[self.newsListViewControllerCache exchangeObjectAtIndex:pageIndex withObjectAtIndex:newPageIndex];
			
			// make sure cache exists before accessing indices
			if (!self.newsListViewControllerCache) {
				break;
			}
			
			// update page indices
			if (self.newsListViewControllerCache[pageIndex] != [NSNull null]) {
				((UHDNewsListViewController *) self.newsListViewControllerCache[pageIndex]).pageIndex = pageIndex;
			}
			if (self.newsListViewControllerCache[newPageIndex] != [NSNull null]) {
				((UHDNewsListViewController *) self.newsListViewControllerCache[pageIndex]).pageIndex = newPageIndex;
			}
			
			break;
		}
		case NSFetchedResultsChangeUpdate: {
		
			// update (i.e. replace) object
			[sources replaceObjectAtIndex:sourceIndex withObject:anObject];
			
			// update 'All Sources VC'
			if (allSourcesVC) {
				allSourcesVC.sources = [NSArray arrayWithArray:sources];
				allSourcesVC.displayMode = self.displayMode;
			}
			
			// update cache (also updates currently displayed source since it is always in cache)
			if (!self.newsListViewControllerCache && (self.newsListViewControllerCache[pageIndex] != [NSNull null])) {
				((UHDNewsListViewController *) self.newsListViewControllerCache[pageIndex]).sources = @[ anObject ];
			}
			
			// clear cache for updated object
			[self.newsListViewControllerCache replaceObjectAtIndex:pageIndex withObject:[NSNull null]];
			
			break;
		}
		default:
			break;
	}
	
	// set modified array of sources to navigation bar
	self.sourcesNavigationBar.sources = [NSArray arrayWithArray:sources];
}

@end
