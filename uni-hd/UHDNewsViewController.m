//
//  UHDNewsViewController.m
//  uni-hd
//
//  Created by Nils Fischer on 06.05.14.
//  Copyright (c) 2014 Universität Heidelberg. All rights reserved.
//

#import "UHDNewsViewController.h"
#import "UHDNewsDetailViewController.h"
#import "UHDNewsItem.h"
#import "VIFetchedResultsControllerDataSource.h"
#import "UHDNewsItemCell.h"
#import "UHDNewsItemCell+ConfigureForItem.h"


@interface UHDNewsViewController ()

@property (strong, nonatomic) id <UHDRemoteDatasource> remoteDatasource;
@property (strong, nonatomic) VIFetchedResultsControllerDataSource *fetchedResultsControllerDataSource;

- (NSManagedObjectContext *)managedObjectContext;

- (IBAction)makeSamplesButtonPressed:(id)sender;

@end

@implementation UHDNewsViewController

- (void)setRemoteDatasource:(id<UHDRemoteDatasource>)remoteDatasource
{
    _remoteDatasource = remoteDatasource;
}
- (NSManagedObjectContext *)managedObjectContext {
    return self.remoteDatasource.managedObjectContext;
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
    [self.remoteDatasource generateSampleData];
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
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"source.subscribed == YES"];
        
        NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        
        VITableViewCellConfigureBlock configureCellBlock = ^(UITableViewCell *cell, UHDNewsItem *item) {
            [(UHDNewsItemCell *)cell configureForItem:item];
        };
        
        self.fetchedResultsControllerDataSource = [[VIFetchedResultsControllerDataSource alloc] initWithFetchedResultsController:fetchedResultsController tableView:self.tableView cellIdentifier:@"newsCell" configureCellBlock:configureCellBlock];
    }
    return _fetchedResultsControllerDataSource;
}


@end
