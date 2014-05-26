//
//  UHDNewsViewController.m
//  uni-hd
//
//  Created by Nils Fischer on 06.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDNewsViewController.h"
#import "VIFetchedResultsControllerDataSource.h"
#import "UHDRemoteDatasourceManager.h"

// View Controllers
#import "UHDNewsDetailViewController.h"
#import "UHDNewsSourcesViewController.h"

// Model
#import "UHDNewsItem.h"
#import "UHDNewsSource.h"

// Table View Cells
#import "UHDNewsItemCell.h"
#import "UHDNewsItemCell+ConfigureForItem.h"


@interface UHDNewsViewController ()

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) VIFetchedResultsControllerDataSource *fetchedResultsControllerDataSource;

- (IBAction)unwindToNews:(UIStoryboardSegue *)segue;
- (IBAction)makeSamplesButtonPressed:(id)sender;

@end

@implementation UHDNewsViewController

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // redirect data source
    self.tableView.dataSource = self.fetchedResultsControllerDataSource;
    
    // TODO: fix update mechanism
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(managedObjectContextDidSave:) name:NSManagedObjectContextDidSaveNotification object:self.managedObjectContext.parentContext];
}


// update sizes of multiline UILabels in TableView
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    for (id cell in [self.tableView visibleCells]) {
        [(UHDNewsItemCell *) cell updateLabelPreferredMaxLayoutWidthToCurrentWidth];
    };
    
    [self.view layoutIfNeeded];
}


#pragma mark - User Interaction

- (IBAction)makeSamplesButtonPressed:(id)sender
{
    [[[UHDRemoteDatasourceManager defaultManager] remoteDatasourceForKey:UHDRemoteDatasourceKeyNews] generateSampleData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showNewsDetail"]) {
        UHDNewsDetailViewController *newsDetailVC = segue.destinationViewController;
        newsDetailVC.newsItem = self.fetchedResultsControllerDataSource.selectedItem;
    } else if ([segue.identifier isEqualToString:@"showSources"]) {
        UHDNewsSourcesViewController *newsSourcesVC = [(UINavigationController *)segue.destinationViewController viewControllers][0];
        newsSourcesVC.managedObjectContext = self.managedObjectContext;
    }
}

- (IBAction)unwindToNews:(UIStoryboardSegue *)segue
{
    
}


#pragma mark - Data Source

- (VIFetchedResultsControllerDataSource *)fetchedResultsControllerDataSource
{
    if (!_fetchedResultsControllerDataSource)
    {
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[UHDNewsItem entityName]];
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"source.subscribed == YES"];
        
        NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        
        VITableViewCellConfigureBlock configureCellBlock = ^(UITableViewCell *cell, id item) {
            [(UHDNewsItemCell *)cell configureForItem:item];
        };
        
        self.fetchedResultsControllerDataSource = [[VIFetchedResultsControllerDataSource alloc] initWithFetchedResultsController:fetchedResultsController tableView:self.tableView cellIdentifier:@"newsCell" configureCellBlock:configureCellBlock];
    }
    return _fetchedResultsControllerDataSource;
}


#pragma mark - Core Data Change Notification

- (void)managedObjectContextDidSave:(NSNotification *)notification
{
    for (NSManagedObject *object in notification.userInfo[NSUpdatedObjectsKey]) {
        if ([object isKindOfClass:[UHDNewsSource class]]) {
            [self.fetchedResultsControllerDataSource reloadData];
            break;
        }
    }
}

@end
