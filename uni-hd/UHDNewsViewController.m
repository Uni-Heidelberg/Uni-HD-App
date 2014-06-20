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


@interface UHDNewsViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSMutableArray *newsListViewControllers;

@property (strong, nonatomic) IBOutlet UILabel *temporarySelectedSourceLabel; // TODO: implement proper source navigation bar

- (IBAction)showAllNewsButtonPressed:(id)sender;
- (IBAction)unwindToNews:(UIStoryboardSegue *)segue;

@end


@implementation UHDNewsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // TODO: fix scroll view insets & extend under both bars
    
    [self configureView];
}

- (void)configureView
{
    self.temporarySelectedSourceLabel.text = [self.pageViewController.viewControllers[0] title];
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

- (IBAction)showAllNewsButtonPressed:(id)sender
{
    [self.pageViewController setViewControllers:@[ self.newsListViewControllers[0] ] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    // TODO/BUG: neighbouring view controllers are not updated
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showSources"]) {
        
        UHDNewsSourcesViewController *newsSourcesVC = (UHDNewsSourcesViewController *)[(UINavigationController *)segue.destinationViewController topViewController];
        newsSourcesVC.managedObjectContext = self.managedObjectContext;

    } else if ([segue.identifier isEqualToString:@"embedPageVC"]) {
        self.pageViewController = (UIPageViewController *)segue.destinationViewController;
        self.pageViewController.dataSource = self;
        self.pageViewController.delegate = self;
        [self.pageViewController setViewControllers:@[ [self pageViewController:self.pageViewController viewControllerAfterViewController:nil] ] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    }
}

- (IBAction)unwindToNews:(UIStoryboardSegue *)segue
{
    
}


#pragma mark - Page View Controller Delegate

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    [self configureView];
}


#pragma mark - Page View Controller Datasource

- (NSMutableArray *)newsListViewControllers
{
    if (!_newsListViewControllers) {
        NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
        UHDNewsListViewController *allSourcesVC = [self newsListViewControllerForSources:self.fetchedResultsController.fetchedObjects];
        allSourcesVC.title = NSLocalizedString(@"All News", nil);
        [viewControllers addObject:allSourcesVC];
        for (UHDNewsSource *source in self.fetchedResultsController.fetchedObjects) {
            [viewControllers addObject:[self newsListViewControllerForSources:@[ source ]]];
        }
        self.newsListViewControllers = viewControllers;
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
        currentIndex = -1;
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
