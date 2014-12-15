//
//  UHDNewsViewController.m
//  uni-hd
//
//  Created by Nils Fischer on 06.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDNewsViewController.h"

// View Controllers
#import "UHDNewsSourcesViewController.h"
#import "UHDNewsListViewController.h"

// Model
#import "UHDNewsSource.h"

// Sources Navigation Bar
#import "UHDNewsSourcesNavigationBar.h"

#define kDisplayModeSegmentIndexNews 0
#define kDisplayModeSegmentIndexEvents 1


@interface UHDNewsViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate, NSFetchedResultsControllerDelegate, UHDNewsSourcesNavigationBarDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSMutableArray *newsListViewControllers;

@property (weak, nonatomic) IBOutlet UHDNewsSourcesNavigationBar *sourcesNavigationBar;
@property (weak, nonatomic) IBOutlet UIButton *sourceButton;

//@property (weak, nonatomic) IBOutlet UISegmentedControl *newsEventsSegmentedControl;

- (IBAction)unwindToNews:(UIStoryboardSegue *)segue;

//- (IBAction)newsEventsSegmentedControlValueChanged:(id)sender;
- (IBAction)sourceButtonPressed:(id)sender;

@end


@implementation UHDNewsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self.navigationController.tabBarItem setSelectedImage:[UIImage imageNamed:@"newsIconSelected"]];

    // TODO: fix scroll view insets & extend under both bars
    
    self.sourcesNavigationBar.delegate = self;
    
    [self configureView];
	
	[(UHDNewsListViewController *)self.pageViewController.viewControllers[0] scrollToToday];
}

- (void)configureView
{
	[self updateDisplayMode];
	
	// set currently subscribed sources to display in sources navigation bar
	self.sourcesNavigationBar.sources = [self.fetchedResultsController fetchedObjects];

    // set currently selected source and update sourceButton
    NSArray *currentSources = ((UHDNewsListViewController *)self.pageViewController.viewControllers[0]).sources;
    if (currentSources.count != 1) {
        self.sourcesNavigationBar.selectedSource = nil;
    } else {
        self.sourcesNavigationBar.selectedSource = currentSources[0];
    }
	
	[self updateSourceButton];
    
    // make sure only active table view scrolls to top
    for (UHDNewsListViewController *vc in self.newsListViewControllers) {
        vc.tableView.scrollsToTop = [self.pageViewController.viewControllers containsObject:vc];
    }
}

#pragma mark - Fetched Results Controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (!_fetchedResultsController)
    {
        if (!self.managedObjectContext) {
            [self.logger log:@"Unable to create fetched results controller without a managed object context" forLevel:VILogLevelWarning];
            return nil;
        }
        
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[UHDNewsSource entityName]];
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"subscribed == YES"];
        fetchRequest.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES] ];
        
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        self.fetchedResultsController.delegate = self;
        [self.fetchedResultsController performFetch:NULL];
    }
    return _fetchedResultsController;
}


#pragma mark - User Interaction

/*
- (IBAction)newsEventsSegmentedControlValueChanged:(id)sender {
	[self updateDisplayMode];
}
*/

- (IBAction)sourceButtonPressed:(id)sender {
	
	[self configureView];
	
}


- (void)updateDisplayMode
{
	for (UHDNewsListViewController *newsListVC in self.newsListViewControllers) {
		/*
		switch (self.newsEventsSegmentedControl.selectedSegmentIndex) {
			case kDisplayModeSegmentIndexNews:
				newsListVC.displayMode = UHDNewsListDisplayModeNews;
				break;
			case kDisplayModeSegmentIndexEvents:
				newsListVC.displayMode = UHDNewsListDisplayModeEvents;
				break;
			default:
				break;
		}
		*/
		newsListVC.displayMode = UHDNewsListDisplayModeAll;
	}
}


- (void)updateSourceButton {
	
	UHDNewsSource *source = self.sourcesNavigationBar.selectedSource;
	
	if (source == nil) {
		[self.sourceButton setTitle:NSLocalizedString(@"Alle News und Veranstaltungen", nil) forState:UIControlStateNormal];
	}
	else {
		[self.sourceButton setTitle:source.title forState:UIControlStateNormal];
	}
	
	self.sourceButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
	self.sourceButton.titleLabel.textAlignment = NSTextAlignmentCenter;
	self.sourceButton.titleLabel.numberOfLines = 2;
	
	[self.sourceButton sizeToFit];
}


- (IBAction)todayButtonPressed:(id)sender {
	
	[self.pageViewController.viewControllers[0] scrollToToday];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showSources"]) {
        UHDNewsSourcesViewController *newsSourcesVC = (UHDNewsSourcesViewController *)[(UINavigationController *)segue.destinationViewController topViewController];
        newsSourcesVC.managedObjectContext = self.managedObjectContext;
    } else if ([segue.identifier isEqualToString:@"embedPageVC"]) {
        self.pageViewController = segue.destinationViewController;
        self.pageViewController.dataSource = self;
        self.pageViewController.delegate = self;
        [self.pageViewController setViewControllers:@[ self.newsListViewControllers[0] ] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    }
}

- (IBAction)unwindToNews:(UIStoryboardSegue *)segue
{
    
}

#pragma mark - Sources Navigation Bar Delegate

- (void)sourcesNavigationBar:(UHDNewsSourcesNavigationBar *)navigationBar didSelectSource:(UHDNewsSource *)source
{
    [self.logger log:[NSString stringWithFormat:@"Switch Page View Controller to Source: %@", source.title] forLevel:VILogLevelDebug];
    
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


#pragma mark - Page View Controller Delegate

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    [self configureView];
	//[((UHDNewsListViewController *)self.pageViewController.viewControllers[0]) scrollToToday];	// looks strange...
}


#pragma mark - Page View Controller Datasource

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
    [self configureView];
}

@end
