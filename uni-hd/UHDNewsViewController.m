//
//  UHDNewsViewController.m
//  uni-hd
//
//  Created by Nils Fischer on 06.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDNewsDetailViewController.h"
#import "UHDNewsViewController.h"
#import "UHDNewsStore.h"
#import "UHDNewsItem.h"
#import "VIFetchedResultsControllerDataSource.h"
#import "UHDNewsItemCell.h"
#import "UHDNewsItemCell+ConfigureForItem.h"


@interface UHDNewsViewController ()

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) VIFetchedResultsControllerDataSource *fetchedResultsControllerDataSource;

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
    
    self.title = NSLocalizedString(@"News", nil);
    
    // redirect data source
    self.tableView.dataSource = self.fetchedResultsControllerDataSource;
    
}


#pragma mark - User Interaction

- (IBAction)makeSamplesButtonPressed:(id)sender
{
    [[UHDNewsStore defaultStore] generateSampleData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    UHDNewsItem *selectedNewsItem = self.fetchedResultsControllerDataSource.selectedItem;
    
    UHDNewsDetailViewController *newsDetailVC = segue.destinationViewController;
    
    newsDetailVC.newsItem = selectedNewsItem;
    
    // [self.logger log:@"Segue selected" forLevel:VILogLevelDebug];
    
}


#pragma mark - Data Source

- (VIFetchedResultsControllerDataSource *)fetchedResultsControllerDataSource
{
    if (!_fetchedResultsControllerDataSource)
    {
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[UHDNewsItem entityName]];
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
        
        NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        
        VITableViewCellConfigureBlock configureCellBlock = ^(UITableViewCell *cell, UHDNewsItem *item) {
            [(UHDNewsItemCell *)cell configureForItem:item];
        };
        
        self.fetchedResultsControllerDataSource = [[VIFetchedResultsControllerDataSource alloc] initWithFetchedResultsController:fetchedResultsController tableView:self.tableView cellIdentifier:@"newsCell" configureCellBlock:configureCellBlock];
    }
    return _fetchedResultsControllerDataSource;
}


@end
